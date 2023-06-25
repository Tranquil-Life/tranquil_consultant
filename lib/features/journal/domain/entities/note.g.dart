// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'id':instance.id ?? null,
  'heading': instance.title,
  'body': instance.description,
  'mood': instance.mood,
  'color':instance.hexColor
};