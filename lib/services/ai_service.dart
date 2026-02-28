import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'http://10.0.2.2:8000'; // for Android emulator
  // For iOS simulator or physical device, use your local IP: 'http://192.168.x.x:8000'

  static Future<String> getResponse(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/ask'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'];
      } else {
        return 'Désolé, le serveur a répondu avec une erreur (${response.statusCode}). Veuillez réessayer.';
      }
    } catch (e) {
      return 'Impossible de joindre le serveur. Vérifiez votre connexion et que le backend est lancé.';
    }
  }
}
