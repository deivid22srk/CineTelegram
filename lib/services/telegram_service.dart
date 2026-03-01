import 'dart:convert';
import 'package:http/http.dart' as http;

class TelegramService {
  final String botToken;
  final String groupId;

  TelegramService({required this.botToken, required this.groupId});

  // Base URL for Telegram Bot API
  String get baseUrl => 'https://api.telegram.org/bot$botToken';

  /// Fetches the direct download link for a given file_id.
  /// Note: Telegram Bot API links for files are only valid for a limited time.
  Future<String?> getFileLink(String fileId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getFile?file_id=$fileId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final filePath = data['result']['file_path'];
          return 'https://api.telegram.org/file/bot$botToken/$filePath';
        }
      }
    } catch (e) {
      print('Error fetching file link: $e');
    }
    return null;
  }

  /// In a real-world scenario, you might want to use a proxy/streaming server
  /// because direct Telegram file links have limitations (size, speed, expiration).
  /// For this demo/app, we'll use the direct link.
  String getStreamingUrl(String telegramFileId) {
    // This could be replaced with a custom worker or server that streams the file
    // for better performance and to bypass the 20MB limit for some bot API calls,
    // although getFile works up to 20MB directly, and larger files need different approaches
    // like MTProto or a specialized proxy.
    // For simplicity, we'll assume we can get a link.
    return ''; // Will be resolved dynamically in the player or provider
  }
}
