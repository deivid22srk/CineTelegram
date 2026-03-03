import 'package:cine_telegram/models/media.dart';
import 'package:cine_telegram/models/movie.dart';
import 'package:cine_telegram/models/series.dart';
import 'package:cine_telegram/services/storage_service.dart';
import 'package:cine_telegram/services/telegram_mtproto_service.dart';
import 'package:flutter/material.dart';

class MediaProvider extends ChangeNotifier {
  final StorageService storageService;
  List<Media> _mediaList = [];
  String? _botToken;
  String? _groupId;
  String? _apiId;
  String? _apiHash;
  bool _isLoggedIn = false;

  MediaProvider(this.storageService) {
    _loadFromStorage();
    _loadSettings();
  }

  List<Media> get mediaList => _mediaList;
  List<Movie> get movies => _mediaList.whereType<Movie>().toList();
  List<Series> get series => _mediaList.whereType<Series>().toList();
  String? get botToken => _botToken;
  String? get groupId => _groupId;
  String? get apiId => _apiId;
  String? get apiHash => _apiHash;
  bool get isLoggedIn => _isLoggedIn;

  Map<String, List<Media>> get mediaByCategory {
    final Map<String, List<Media>> categories = {};
    for (var media in _mediaList) {
      categories.putIfAbsent(media.category, () => []).add(media);
    }
    return categories;
  }

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
      _apiId = settings['apiId'];
      _apiHash = settings['apiHash'];
    }
    notifyListeners();
  }

  Future<void> updateSettings({
    required String token,
    required String groupId,
    required String apiId,
    required String apiHash,
  }) async {
    _botToken = token;
    _groupId = groupId;
    _apiId = apiId;
    _apiHash = apiHash;
    await storageService.saveTelegramSettings(
      token: token,
      groupId: groupId,
      apiId: apiId,
      apiHash: apiHash,
    );
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

  Future<void> backup() async {
    if (_botToken == null || _apiId == null || _apiHash == null || _groupId == null) return;
    final service = TelegramMtprotoService(botToken: _botToken!, apiId: _apiId!, apiHash: _apiHash!);
    final data = jsonEncode(_mediaList.map((e) => e.toJson()).toList());
    await service.backupData(data, _groupId!);
  }

  Future<void> restore() async {
    if (_botToken == null || _apiId == null || _apiHash == null || _groupId == null) return;
    final service = TelegramMtprotoService(botToken: _botToken!, apiId: _apiId!, apiHash: _apiHash!);
    final data = await service.restoreData(_groupId!);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _mediaList = decoded.map((json) {
        if (json['type'] == 'series') return Series.fromJson(json);
        return Movie.fromJson(json);
      }).toList();
      await _saveMediaListToStorage();
      notifyListeners();
    }
  }

  Future<int> getProgress(String id) async {
    return storageService.getProgress(id);
  }

  Future<void> saveProgress(String id, int seconds) async {
    await storageService.saveProgress(id, seconds);
    notifyListeners();
  }

  Future<String?> getMediaStreamUrl(String telegramFileId) async {
    // Logic uses StreamingServer localhost URL
    return 'http://127.0.0.1:8080/stream/$telegramFileId';
  }
}
