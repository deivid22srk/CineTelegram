// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  posterUrl: json['posterUrl'] as String,
  backdropUrl: json['backdropUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  year: (json['year'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  seasons: (json['seasons'] as List<dynamic>)
      .map((e) => Season.fromJson(e as Map<String, dynamic>))
      .toList(),
  type:
      $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ?? MediaType.series,
);

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'posterUrl': instance.posterUrl,
  'backdropUrl': instance.backdropUrl,
  'rating': instance.rating,
  'year': instance.year,
  'genres': instance.genres,
  'type': _$MediaTypeEnumMap[instance.type]!,
  'seasons': instance.seasons,
};

const _$MediaTypeEnumMap = {
  MediaType.movie: 'movie',
  MediaType.series: 'series',
};
