import 'package:dio/dio.dart';
import 'package:flutter_novu/enums.dart';

class BaseApi {
  final String baseUrl;
  final String? apiKey;
  late final Dio client;

  BaseApi(this.baseUrl, [this.apiKey]) {
    client = Dio();
    client.options.baseUrl = '$baseUrl/v1/';
    if (apiKey != null) {
      client.options.headers['Authorization'] = 'ApiKey $apiKey';
    }
  }

  Future<Map<String, dynamic>> request({
    required ApiMethod method,
    required String endpoint,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    headers = {
      ...?headers,
    };

    var response = await client.request<Map<String, dynamic>>(
        endpoint,
        data: data,
        queryParameters: query,
        options: Options(headers: headers, method: method.name.toUpperCase())
    );

    return response.data!;
  }
}