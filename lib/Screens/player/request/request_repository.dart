import 'dart:convert';

import '../../../utils/api_client.dart';
import 'request.dart';

abstract class RequestRepository {
  Future<List<Request>> getRequests(String userId);
  Future<bool> acceptRequest(int requestId);
  Future<bool> rejectRequest(int requestId);
}

class RequestRepositoryImpl implements RequestRepository {
  final ApiClient apiClient;

  RequestRepositoryImpl(this.apiClient);

  @override
  Future<List<Request>> getRequests(String userId) async {
    final response = await apiClient
        .get('security_filter/v1/api/social/follow?userId=$userId');

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<dynamic> data = body['requests'];
      print(data);
      return data.map((e) => Request.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  }

  @override
  Future<bool> acceptRequest(int requestId) async {
    final response = await apiClient.put(
      'security_filter/v1/api/social/follow',
      {"requestId": requestId, 'action': "accepted"},
    );

    return response.statusCode == 200;
  }

  @override
  Future<bool> rejectRequest(int requestId) async {
    final response = await apiClient.put(
      'security_filter/v1/api/social/follow',
      {"requestId": requestId, 'action': "rejected"},
    );

    return response.statusCode == 200;
  }
}
