import '../../../src/registration/data/models/player_full_model.dart';
import '../../../utils/video_model.dart';
import 'player_repository.dart';

class PlayerUseCase {
  final PlayerRepository repository;

  PlayerUseCase(this.repository);

  Future<UserProfileResponse?> getPlayerInfo(String userId, String currentUserId) {
    return repository.getPlayerInfo(userId, currentUserId);
  }

  Future<List<Video>> getPlayerVideos(String userId) {
    return repository.getPlayerVideos(userId);
  }
}
