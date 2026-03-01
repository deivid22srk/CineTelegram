import 'package:cine_telegram/models/media.dart';
import 'package:cine_telegram/models/season.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@JsonSerializable()
class Series extends Media {
  final List<Season> seasons;

  Series({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    required super.backdropUrl,
    required super.rating,
    required super.year,
    required super.genres,
    required this.seasons,
    super.type = MediaType.series,
  });

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
