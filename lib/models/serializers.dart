abstract class SerializableDocument {
  Map<String, dynamic> toJson();
}

Map<String, dynamic> serializeDocument<T extends SerializableDocument>(T doc) {
  return doc.toJson();
}

List<Map<String, dynamic>> serializeList<T extends SerializableDocument>(
  List<T> docs,
) {
  return docs.map((doc) => doc.toJson()).toList();
}
