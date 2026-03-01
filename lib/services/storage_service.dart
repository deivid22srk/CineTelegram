import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyMediaList = 'media_list';
  static const String keyProgressPrefix = 'progress_';
  static const String keyTelegramSettings = 'telegram_settings';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  /// Saves the list of media (movies/series) locally.
  Future<void> saveMediaList(List<Map<String, dynamic>> mediaList) async {
    await prefs.setString(keyMediaList, json.encode(mediaList));
  }

  /// Retrieves the list of media from local storage.
  List<Map<String, dynamic>> getMediaList() {
    final String? data = prefs.getString(keyMediaList);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = json.decode(data);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Saves the playback progress (in seconds) for a media/episode ID.
  Future<void> saveProgress(String id, int seconds) async {
    await prefs.setInt('$keyProgressPrefix$id', seconds);
  }

  /// Retrieves the saved playback progress (in seconds) for a media/episode ID.
  int getProgress(String id) {
    return prefs.getInt('$keyProgressPrefix$id') ?? 0;
  }

  /// Saves Telegram Bot settings (token and group ID).
  Future<void> saveTelegramSettings(String token, String groupId) async {
    final settings = {'token': token, 'groupId': groupId};
    await prefs.setString(keyTelegramSettings, json.encode(settings));
  }

  /// Retrieves the Telegram Bot settings.
  Map<String, String>? getTelegramSettings() {
    final String? data = prefs.getString(keyTelegramSettings);
    if (data == null) return null;
    try {
      final Map<String, dynamic> decoded = json.decode(data);
      return {
        'token': decoded['token'] ?? '',
        'groupId': decoded['groupId'] ?? '',
      };
    } catch (e) {
      return null;
    }
  }
}
