import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyMediaList = 'media_list';
  static const String keyProgressPrefix = 'progress_';
  static const String keyTelegramSettings = 'telegram_settings';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  Future<void> saveMediaList(List<Map<String, dynamic>> mediaList) async {
    await prefs.setString(keyMediaList, json.encode(mediaList));
  }

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

  Future<void> saveProgress(String id, int seconds) async {
    await prefs.setInt('$keyProgressPrefix$id', seconds);
  }

  int getProgress(String id) {
    return prefs.getInt('$keyProgressPrefix$id') ?? 0;
  }

  Future<void> saveTelegramSettings({
    required String token,
    required String groupId,
    required String apiId,
    required String apiHash,
  }) async {
    final settings = {
      'token': token,
      'groupId': groupId,
      'apiId': apiId,
      'apiHash': apiHash,
    };
    await prefs.setString(keyTelegramSettings, json.encode(settings));
  }

  Map<String, String>? getTelegramSettings() {
    final String? data = prefs.getString(keyTelegramSettings);
    if (data == null) return null;
    try {
      final Map<String, dynamic> decoded = json.decode(data);
      return {
        'token': decoded['token'] ?? '',
        'groupId': decoded['groupId'] ?? '',
        'apiId': decoded['apiId'] ?? '',
        'apiHash': decoded['apiHash'] ?? '',
      };
    } catch (e) {
      return null;
    }
  }
}
