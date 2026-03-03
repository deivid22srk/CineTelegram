import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

enum MediaType {
  @JsonValue('movie') movie,
  @JsonValue('series') series
}

@JsonSerializable()
class Media {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final int year;
  final List<String> genres;
  final MediaType type;
  final String category; // New field

  Media({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.year,
    required this.genres,
    required this.type,
    this.category = 'Geral', // Default category
  });

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
