import 'package:cine_telegram/models/episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season.g.dart';

@JsonSerializable()
class Season {
  final String id;
  final String title;
  final int number;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.title,
    required this.number,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}
