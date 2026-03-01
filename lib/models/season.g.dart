// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Season _$SeasonFromJson(Map<String, dynamic> json) => Season(
  id: json['id'] as String,
  title: json['title'] as String,
  number: (json['number'] as num).toInt(),
  episodes: (json['episodes'] as List<dynamic>)
      .map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'number': instance.number,
  'episodes': instance.episodes,
};
