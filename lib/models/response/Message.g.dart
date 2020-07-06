// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$messageFromJson(Map<dynamic, dynamic> json) {
  return Message(
    type: json['type'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    message: json['message'] as String,
  );
}

Map<dynamic, dynamic> _$messageToJson(Message instance) => <dynamic, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'image': instance.image,
      'message': instance.message,
    };
