import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'serializers.dart';
part 'pages.g.dart';

@JsonSerializable()
class OrderedPageEntry extends SerializableDocument {
  static const Uuid _uuid = Uuid();

  late String id;
  String? title;
  String content;
  bool active;

  OrderedPageEntry({
    String? id,
    this.title,
    this.content = '',
    this.active = true,
  }) {
    this.id = id ?? _uuid.v4();
  }

  @override
  Map<String, dynamic> toJson() => _$OrderedPageEntryToJson(this);
  factory OrderedPageEntry.fromJson(Map<String, dynamic> json) =>
      _$OrderedPageEntryFromJson(json);
}

// Without this the build complains about the generic type
List<Map<String, dynamic>> _serializeList(List<OrderedPageEntry> docs) =>
    serializeList(docs);

@JsonSerializable()
class OrderedPage extends SerializableDocument {
  @JsonKey(toJson: _serializeList)
  late List<OrderedPageEntry> entries;

  OrderedPage(List<OrderedPageEntry>? entries) {
    this.entries = entries ?? [];
  }

  @override
  Map<String, dynamic> toJson() => _$OrderedPageToJson(this);
  factory OrderedPage.fromJson(Map<String, dynamic> json) =>
      _$OrderedPageFromJson(json);
}
