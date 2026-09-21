import 'package:flutter_novu/api/base.dart';
import 'package:flutter_novu/dot/message.dart';
import 'package:flutter_novu/dot/shared.dart';
import 'package:flutter_novu/enums.dart';

class MessageApi extends BaseApi {
  MessageApi(super.baseUrl, super.apiKey);

  Future<PaginatedResponse<Message>> getMessages(List<String> channels, [String? subscriberId]) async {
    Map<String, dynamic> response = await request(method: ApiMethod.get, endpoint: 'messages', query: {'subscriberId': subscriberId, 'channels': channels.join(',')});
    return PaginatedResponse<Message>(
      page: response['page'],
      totalCount: response['totalCount'],
      pageSize: response['pageSize'],
      hasMore: response['hasMore'],
      data: response['data'].map<Message>((var r) => Message.fromJson(r)).toList(),
    );
  }

  Future<bool> deleteMessage(String messageId) async {
    Map<String, dynamic> response = await request(method: ApiMethod.delete, endpoint: 'messages/$messageId');
    return response['data']?['acknowledged'] == true;
  }

  Future<bool> deleteMessageByTransactionId(String transactionId) async {
    await request(method: ApiMethod.delete, endpoint: 'messages/transaction/$transactionId');
    return true;
  }
}