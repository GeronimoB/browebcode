import 'request.dart';
import 'request_repository.dart';

class RequestUseCase {
  final RequestRepository repository;

  RequestUseCase(this.repository);

  Future<List<Request>> getRequests(String userId) async {
    return await repository.getRequests(userId);
  }

  Future<bool> acceptRequest(int requestId) async {
    return await repository.acceptRequest(requestId);
  }

  Future<bool> rejectRequest(int requestId) async {
    return await repository.rejectRequest(requestId);
  }
}
