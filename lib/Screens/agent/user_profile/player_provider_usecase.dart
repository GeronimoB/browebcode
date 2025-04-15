import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../src/registration/data/models/player_full_model.dart';
import '../../../utils/api_client.dart';
import '../../../utils/video_model.dart';
import 'player_repository.dart';
import 'player_usecase.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Provider del PlayerRepository
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PlayerRepository(apiClient);
});
// Provider de PlayerUseCase
final playerUseCaseProvider = Provider<PlayerUseCase>((ref) {
  final repository = ref.watch(playerRepositoryProvider);
  return PlayerUseCase(repository);
});

// Estado del jugador
final playerProvider = FutureProvider.autoDispose
    .family<UserProfileResponse?, PlayerInfoParams>((ref, params) {
  final useCase = ref.watch(playerUseCaseProvider);
  return useCase.getPlayerInfo(params.userId, params.currentUserId);
});

// Estado de los videos del jugador
final videosProvider =
    FutureProvider.autoDispose.family<List<Video>, String>((ref, userId) {
  final useCase = ref.watch(playerUseCaseProvider);
  return useCase.getPlayerVideos(userId);
});

class PlayerInfoParams {
  final String userId;
  final String currentUserId;

  PlayerInfoParams({required this.userId, required this.currentUserId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerInfoParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          currentUserId == other.currentUserId;

  @override
  int get hashCode => userId.hashCode ^ currentUserId.hashCode;
}
