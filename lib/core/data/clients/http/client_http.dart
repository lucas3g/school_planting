import '../../../domain/entities/response_entity.dart';

abstract class ClientHttp {
  Future<HttpResponseEntity<T>> patch<T>(
    String path, {
    Map<String, dynamic>? data,
  });

  Future<HttpResponseEntity<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
  });

  Future<HttpResponseEntity<T>> get<T>(String path);

  Future<HttpResponseEntity<T>> getImage<T>(String path);

  Future<HttpResponseEntity<T>> delete<T>(String path);

  void setBaseUrl(String url);
  void setHeaders(Map<String, dynamic> header);
}
