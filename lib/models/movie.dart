import 'package:cine_telegram/models/media.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Media {
  final String videoUrl;
  final String telegramFileId;

  Movie({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    required super.backdropUrl,
    required super.rating,
    required super.year,
    required super.genres,
    this.videoUrl = '',
    this.telegramFileId = '',
    super.type = MediaType.movie,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
