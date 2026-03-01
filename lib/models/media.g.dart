// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  posterUrl: json['posterUrl'] as String,
  backdropUrl: json['backdropUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  year: (json['year'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
);

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'posterUrl': instance.posterUrl,
  'backdropUrl': instance.backdropUrl,
  'rating': instance.rating,
  'year': instance.year,
  'genres': instance.genres,
  'type': _$MediaTypeEnumMap[instance.type]!,
};

const _$MediaTypeEnumMap = {
  MediaType.movie: 'movie',
  MediaType.series: 'series',
};
