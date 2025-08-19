class HttpServerResponse {
  int code;
  String message;
  dynamic data;

  HttpServerResponse({
    required this.code,
    required this.message,
    required this.data,
  });
}