// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  id: json['id'] as String,
  title: json['title'] as String,
  number: (json['number'] as num).toInt(),
  description: json['description'] as String,
  thumbnail: json['thumbnail'] as String,
  videoUrl: json['videoUrl'] as String? ?? '',
  telegramFileId: json['telegramFileId'] as String? ?? '',
  durationInSeconds: (json['durationInSeconds'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'number': instance.number,
  'description': instance.description,
  'thumbnail': instance.thumbnail,
  'videoUrl': instance.videoUrl,
  'telegramFileId': instance.telegramFileId,
  'durationInSeconds': instance.durationInSeconds,
};
