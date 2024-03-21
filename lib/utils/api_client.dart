import 'package:bro_app_to/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = ApiConstants.baseUrl;

  ApiClient();

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            body: body,
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } catch (e) {
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }
}
