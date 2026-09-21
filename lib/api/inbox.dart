import 'package:flutter_novu/api/base.dart';
import 'package:flutter_novu/dot/inbox_notification.dart';
import 'package:flutter_novu/dot/shared.dart';
import 'package:flutter_novu/enums.dart';

class InboxApi extends BaseApi {
  InboxApi(super.baseUrl, super.apiKey);

  Future<PaginatedResponse<InboxNotification>> getNotifications({
    bool archived = false,
    int page = 0,
    int limit = 10,
    List<String>? tags,
  }) async {
    Map<String, dynamic> response = await request(
      method: ApiMethod.get,
      endpoint: 'inbox/notifications',
      query: {
        'offset': page * limit,
        'limit': limit,
        'archived': archived,
        if (tags?.isNotEmpty == true) 'tags': tags!.join(','),
      }
    );
    return PaginatedResponse<InboxNotification>(
      page: response['page'] ?? page,
      totalCount: response['totalCount'] ?? 0,
      pageSize: limit,
      hasMore: response['hasMore'],
      data: response['data'].map<InboxNotification>((var r) => InboxNotification.fromJson(r)).toList(),
    );
  }
}