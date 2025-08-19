class JsonMap {
  static Map<String, dynamic> toMap(dynamic source) {
    if (source == null) return {};

    if (source is Map<String, dynamic>) {
      return source;
    }

    if (source is Map) {
      return source.map((key, value) => MapEntry(key.toString(), value));
    }

    throw ArgumentError("Cannot convert ${source.runtimeType} to Map<String, dynamic>");
  }
}
