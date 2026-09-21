import 'package:flutter_novu/api/base.dart';
import 'package:flutter_novu/dot/notification.dart';
import 'package:flutter_novu/dot/shared.dart';
import 'package:flutter_novu/dot/subscriber.dart';
import 'package:flutter_novu/enums.dart';

/// Server-oriented subscriber API.
///
/// Methods that use [apiKey] (especially credentials) must run on your backend,
/// never inside a mobile app with a Novu secret key.
class SubscriberApi extends BaseApi {
  SubscriberApi(super.baseUrl, super.apiKey);

  static const Map<ProviderId, String> _providerIdValues = {
    ProviderId.slack: 'slack',
    ProviderId.discord: 'discord',
    ProviderId.msteams: 'msteams',
    ProviderId.mattermost: 'mattermost',
    ProviderId.ryver: 'ryver',
    ProviderId.zulip: 'zulip',
    ProviderId.grafanaOnCall: 'grafana-on-call',
    ProviderId.getstream: 'getstream',
    ProviderId.rocketChat: 'rocket-chat',
    ProviderId.whatsappBusiness: 'whatsapp-business',
    ProviderId.fcm: 'fcm',
    ProviderId.apns: 'apns',
    ProviderId.expo: 'expo',
    ProviderId.oneSignal: 'one-signal',
    ProviderId.pushpad: 'pushpad',
    ProviderId.pushWebhook: 'push-webhook',
    ProviderId.pusherBeams: 'pusher-beams',
  };

  /// Resolve the Novu API string for a [ProviderId].
  static String providerIdValue(ProviderId providerId) =>
      _providerIdValues[providerId] ?? providerId.name;

  /// Fetch a subscriber by external id (includes `channels` / device tokens).
  Future<Subscriber> getSubscriber(String subscriberId) async {
    final response = await request(
      method: ApiMethod.get,
      endpoint: 'subscribers/$subscriberId',
    );
    return Subscriber.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// Replace device tokens for a push provider on the subscriber.
  ///
  /// The Novu API **replaces** the entire `deviceTokens` array. Prefer
  /// [addDeviceToken] / [removeDeviceToken] when you need to merge.
  ///
  /// **Do not call from a mobile app with a Novu secret key.** Use your backend.
  Future<void> updateCredentials(
    String subscriberId,
    ProviderId providerId,
    List<String> deviceTokens, {
    String? integrationIdentifier,
  }) async {
    await request(
      method: ApiMethod.put,
      endpoint: 'subscribers/$subscriberId/credentials',
      data: {
        'providerId': providerIdValue(providerId),
        'credentials': {
          'deviceTokens': deviceTokens,
        },
        if (integrationIdentifier != null)
          'integrationIdentifier': integrationIdentifier,
      },
    );
  }

  /// Clear all device tokens for a provider (logout / uninstall).
  Future<void> clearCredentials(
    String subscriberId,
    ProviderId providerId, {
    String? integrationIdentifier,
  }) {
    return updateCredentials(
      subscriberId,
      providerId,
      const [],
      integrationIdentifier: integrationIdentifier,
    );
  }

  /// Append a device token, preserving existing tokens for the provider.
  Future<void> addDeviceToken(
    String subscriberId,
    ProviderId providerId,
    String deviceToken, {
    String? integrationIdentifier,
  }) async {
    final current = await _deviceTokensFor(
      subscriberId,
      providerId,
      integrationIdentifier: integrationIdentifier,
    );
    if (current.contains(deviceToken)) {
      return;
    }
    await updateCredentials(
      subscriberId,
      providerId,
      [...current, deviceToken],
      integrationIdentifier: integrationIdentifier,
    );
  }

  /// Remove a single device token, preserving the rest.
  Future<void> removeDeviceToken(
    String subscriberId,
    ProviderId providerId,
    String deviceToken, {
    String? integrationIdentifier,
  }) async {
    final current = await _deviceTokensFor(
      subscriberId,
      providerId,
      integrationIdentifier: integrationIdentifier,
    );
    final next = current.where((t) => t != deviceToken).toList();
    await updateCredentials(
      subscriberId,
      providerId,
      next,
      integrationIdentifier: integrationIdentifier,
    );
  }

  Future<List<String>> _deviceTokensFor(
    String subscriberId,
    ProviderId providerId, {
    String? integrationIdentifier,
  }) async {
    final subscriber = await getSubscriber(subscriberId);
    final providerValue = providerIdValue(providerId);

    for (final channel in subscriber.channels) {
      final matchesProvider =
          providerIdValue(channel.providerId) == providerValue;
      final matchesIntegration = integrationIdentifier == null ||
          channel.integrationIdentifier == integrationIdentifier;
      if (matchesProvider && matchesIntegration) {
        return List<String>.from(channel.credentials.deviceTokens);
      }
    }
    return const [];
  }

  /// Get subscriber preferences
  ///
  /// [subscriberId] - The external subscriber identifier
  Future<List<SubscriberPreference>> getPreferences(String subscriberId) async {
    List<dynamic> response = (await request(method: ApiMethod.get, endpoint: 'subscribers/$subscriberId/preferences'))['data'];
    return response.map((var r) => SubscriberPreference.fromJson(r)).toList();
  }


  Future<List<SubscriberPreference>> getPreferencesByLevel(String subscriberId, SubscriberPreferenceLevel level) async {
    List<dynamic> response = (await request(method: ApiMethod.get, endpoint: 'subscribers/$subscriberId/preferences/${level.name}'))['data'];
    return response.map((var r) => SubscriberPreference.fromJson(r)).toList();
  }

  /// Update subscriber preference
  /// Activates or deactivates a channel for a subscriber on a specific template (workflow)
  ///
  /// [subscriberId] - The external subscriber identifier
  /// [templateId] - The internal template identifier
  /// [channel] - The channel to update
  /// [value] - The new value for the channel
  Future<SubscriberPreference> updatePreference(String subscriberId, String templateId, String channel, bool value) async {
    Map<String, dynamic> response = await request(
      method: ApiMethod.patch,
      endpoint: 'subscribers/$subscriberId/preferences/$templateId',
      data: {
        'channel': {
          'type': channel,
          'enabled': value,
        },
      }
    );
    return SubscriberPreference.fromJson(response['data']);
  }

  /// Get the number of unread in-app notifications for a subscriber
  ///
  /// [subscriberId] - The external subscriber identifier
  Future<int> getUnseenInAppNotificationCount(String subscriberId) async {
    Map<String, dynamic> response = (await request(method: ApiMethod.get, endpoint: 'subscribers/$subscriberId/notifications/unseen'))['data'];
    return response['count']?.toInt() ?? 0;
  }

  Future<PaginatedResponse<Notification>> getInAppNotifications(String subscriberId, {int? page, int? limit, bool? read, bool? seen}) async {
    Map<String, dynamic> response = await request(method: ApiMethod.get, endpoint: 'subscribers/$subscriberId/notifications/feed', query: {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (read != null) 'read': read,
      if (seen != null) 'seen': seen,
    });
    return PaginatedResponse<Notification>(
      page: response['page'],
      totalCount: response['totalCount'],
      pageSize: response['pageSize'],
      hasMore: response['hasMore'],
      data: response['data'].map<Notification>((var r) => Notification.fromJson(r)).toList(),
    );
  }

  Future<Notification?> markInAppNotificationAs(String subscriberId, String messageId, MarkNotificationAs status) async {
    var ret = await request(method: ApiMethod.post, endpoint: 'subscribers/$subscriberId/messages/mark-as', data: {
      'messageId': messageId,
      'markAs': status.name,
    });
    if (ret['data'].isNotEmpty) {
      return Notification.fromJson(ret['data'].first);
    }
    return null;
  }

  Future<int> markInAppNotificationsAs(String subscriberId, MarkNotificationAs status, [String? feedIdentifier]) async {
    var ret = await request(method: ApiMethod.post, endpoint: 'subscribers/$subscriberId/messages/mark-all', data: {
      if (feedIdentifier != null) 'feedIdentifier': feedIdentifier,
      'markAs': status.name,
    });
    return ret['data'] as int;
  }
}
