import 'package:flutter_novu/api/base.dart';
import 'package:flutter_novu/dot/notification.dart';
import 'package:flutter_novu/dot/shared.dart';
import 'package:flutter_novu/enums.dart';

class NotificationApi extends BaseApi {
  NotificationApi(super.baseUrl, super.apiKey);

  Future<PaginatedResponse<Notification>> getNotifications({
    List<String>? channels,
    List<String>? emails,
    List<String>? subscriberIds,
    String? search,
    int page = 0,
    int limit = 10,
    String? transactionId,
  }) async {
    Map<String, dynamic> response = await request(
      method: ApiMethod.get,
      endpoint: 'notifications',
      query: {
        if (channels != null) 'channels': channels.join(','),
        if (emails != null) 'emails': emails.join(','),
        if (subscriberIds != null) 'subscriberIds': subscriberIds.join(','),
        if (search != null) 'search': search,
        'page': page,
        'limit': limit,
        if (transactionId != null) 'transactionId': transactionId,
      }
    );
    return PaginatedResponse<Notification>(
      page: response['page'],
      totalCount: response['totalCount'],
      pageSize: response['pageSize'],
      hasMore: response['hasMore'],
      data: response['data'].map<Notification>((var r) => Notification.fromJson(r)).toList(),
    );
  }
}