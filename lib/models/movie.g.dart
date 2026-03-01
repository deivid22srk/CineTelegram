// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  posterUrl: json['posterUrl'] as String,
  backdropUrl: json['backdropUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  year: (json['year'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  videoUrl: json['videoUrl'] as String? ?? '',
  telegramFileId: json['telegramFileId'] as String? ?? '',
  type:
      $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ?? MediaType.movie,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'posterUrl': instance.posterUrl,
  'backdropUrl': instance.backdropUrl,
  'rating': instance.rating,
  'year': instance.year,
  'genres': instance.genres,
  'type': _$MediaTypeEnumMap[instance.type]!,
  'videoUrl': instance.videoUrl,
  'telegramFileId': instance.telegramFileId,
};

const _$MediaTypeEnumMap = {
  MediaType.movie: 'movie',
  MediaType.series: 'series',
};
