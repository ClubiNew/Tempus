// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderedPageEntry _$OrderedPageEntryFromJson(Map<String, dynamic> json) =>
    OrderedPageEntry(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$OrderedPageEntryToJson(OrderedPageEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'active': instance.active,
    };

OrderedPage _$OrderedPageFromJson(Map<String, dynamic> json) => OrderedPage(
      (json['entries'] as List<dynamic>?)
          ?.map((e) => OrderedPageEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderedPageToJson(OrderedPage instance) =>
    <String, dynamic>{
      'entries': _serializeList(instance.entries),
    };
