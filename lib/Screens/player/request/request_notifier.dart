import 'package:bro_app_to/Screens/player/request/request_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/api_client.dart';
import 'request.dart';
import 'request_usecase.dart';

class RequestState {
  final List<Request> requests;
  final bool isLoading;
  final String errorMessage;

  RequestState({
    this.requests = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  RequestState copyWith({
    List<Request>? requests,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RequestNotifier extends StateNotifier<RequestState> {
  final RequestUseCase useCase;

  RequestNotifier(this.useCase) : super(RequestState());

  Future<void> loadRequests(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final requests = await useCase.getRequests(userId);
      state = state.copyWith(requests: requests, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<String?> acceptRequest(int requestId, String userId) async {
    try {
      final success = await useCase.acceptRequest(requestId);
      if (success) {
        await loadRequests(userId);
        return 'Solicitud aceptada';
      }
    } catch (e) {
      return 'Error al aceptar: $e';
    }
    return null;
  }

  Future<String?> rejectRequest(int requestId, String userId) async {
    try {
      final success = await useCase.rejectRequest(requestId);
      if (success) {
        await loadRequests(userId);
        return 'Solicitud rechazada';
      }
    } catch (e) {
      return 'Error al rechazar: $e';
    }
    return null;
  }
}

final requestProvider =
    StateNotifierProvider<RequestNotifier, RequestState>((ref) {
  final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
  final apiClient = ref.watch(apiClientProvider);
  final requestRepository = RequestRepositoryImpl(apiClient);
  final requestUseCase = RequestUseCase(requestRepository);
  return RequestNotifier(requestUseCase);
});
