import 'dart:convert';
import 'package:cine_telegram/models/media.dart';
import 'package:cine_telegram/models/movie.dart';
import 'package:cine_telegram/models/series.dart';
import 'package:cine_telegram/services/storage_service.dart';
import 'package:cine_telegram/services/telegram_service.dart';
import 'package:flutter/material.dart';

class MediaProvider extends ChangeNotifier {
  final StorageService storageService;
  List<Media> _mediaList = [];
  String? _botToken;
  String? _groupId;

  MediaProvider(this.storageService) {
    _loadFromStorage();
    _loadSettings();
  }

  List<Media> get mediaList => _mediaList;
  List<Movie> get movies => _mediaList.whereType<Movie>().toList();
  List<Series> get series => _mediaList.whereType<Series>().toList();
  String? get botToken => _botToken;
  String? get groupId => _groupId;

  void _loadFromStorage() {
    final List<Map<String, dynamic>> data = storageService.getMediaList();
    _mediaList = data.map((json) {
      if (json['type'] == 'series') {
        return Series.fromJson(json);
      } else {
        return Movie.fromJson(json);
      }
    }).toList();
    notifyListeners();
  }

  void _loadSettings() {
    final settings = storageService.getTelegramSettings();
    if (settings != null) {
      _botToken = settings['token'];
      _groupId = settings['groupId'];
    }
    notifyListeners();
  }

  Future<void> updateSettings(String token, String groupId) async {
    _botToken = token;
    _groupId = groupId;
    await storageService.saveTelegramSettings(token, groupId);
    notifyListeners();
  }

  Future<void> addMedia(Media media) async {
    _mediaList.add(media);
    await _saveMediaListToStorage();
    notifyListeners();
  }

  Future<void> _saveMediaListToStorage() async {
    final List<Map<String, dynamic>> data = _mediaList.map((m) {
      if (m is Movie) return m.toJson();
      if (m is Series) return m.toJson();
      return m.toJson();
    }).toList();
    await storageService.saveMediaList(data);
  }

  Future<int> getProgress(String id) async {
    return storageService.getProgress(id);
  }

  Future<void> saveProgress(String id, int seconds) async {
    await storageService.saveProgress(id, seconds);
    notifyListeners();
  }

  Future<String?> getMediaStreamUrl(String telegramFileId) async {
    if (_botToken == null || _botToken!.isEmpty) return null;
    final telegramService = TelegramService(botToken: _botToken!, groupId: _groupId ?? '');
    return await telegramService.getFileLink(telegramFileId);
  }
}
