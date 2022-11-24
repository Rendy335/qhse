import 'url.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class Request {
  final String url;
  final dynamic body;

  Request({required this.url, required this.body});

  Future<http.Response> post() {
    return http
        .post(urlAPI + url, body: body)
        .timeout(const Duration(minutes: 2));
  }

  Future<http.Response> get() {
    return http.get(urlAPI + url).timeout(const Duration(minutes: 2));
  }
}
