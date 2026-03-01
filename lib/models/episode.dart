import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable()
class Episode {
  final String id;
  final String title;
  final int number;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final String telegramFileId;
  final int durationInSeconds;

  Episode({
    required this.id,
    required this.title,
    required this.number,
    required this.description,
    required this.thumbnail,
    this.videoUrl = '',
    this.telegramFileId = '',
    this.durationInSeconds = 0,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
