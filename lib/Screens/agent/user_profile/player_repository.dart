import 'dart:convert';

import '../../../src/registration/data/models/player_full_model.dart';
import '../../../utils/api_client.dart';
import '../../../utils/video_model.dart';

class PlayerRepository {
  final ApiClient apiClient;

  PlayerRepository(this.apiClient);

  Future<UserProfileResponse?> getPlayerInfo(
      String userId, String currentUserId) async {
    try {
      final response = await apiClient
          .get('auth/player/$userId?current_user_id=$currentUserId');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        return UserProfileResponse.fromMap(jsonData);
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      print('Error obteniendo usuario: $e');
    }
    return null;
  }

  Future<List<Video>> getPlayerVideos(String userId) async {
    try {
      final response = await apiClient.get('auth/videos/$userId');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final videos = jsonData["videos"];
        final List<Video> sortedVideos = mapListToVideos(videos);

        // Ordenar los videos: Favoritos primero
        sortedVideos
            .sort((a, b) => (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0));

        return sortedVideos;
      }
    } catch (e) {
      print('Error obteniendo videos: $e');
    }
    return [];
  }
}
