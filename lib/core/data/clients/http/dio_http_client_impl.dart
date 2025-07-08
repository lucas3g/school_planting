import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/failure.dart';
import '../../../domain/entities/http_failure.dart';
import '../../../domain/entities/network_failure.dart';
import '../../../domain/entities/response_entity.dart';
import 'client_http.dart';

@Singleton(as: ClientHttp)
class DioClientHttpImpl implements ClientHttp {
  final Dio _dio;

  DioClientHttpImpl({required Dio dio}) : _dio = dio;

  @override
  Future<HttpResponseEntity<T>> patch<T>(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final String url = path;
      final Response<T> dioResponse = await _dio.patch(url, data: data);
      return HttpResponseEntity<T>(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode ?? 200,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<HttpResponseEntity<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final String url = path;

      final Response<T> dioResponse = await _dio.post(url, data: data);

      return HttpResponseEntity<T>(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode ?? 200,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<HttpResponseEntity<T>> get<T>(String path) async {
    try {
      final String url = path;
      final Response<T> dioResponse = await _dio.get(url);
      return HttpResponseEntity<T>(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode ?? 200,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<HttpResponseEntity<T>> delete<T>(String path) async {
    try {
      final String url = path;
      final Response<T> dioResponse = await _dio.delete(url);
      return HttpResponseEntity<T>(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode ?? 200,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  AppFailure _handleError(dynamic e) {
    if (e is DioException) {
      final Map<Object, AppFailure> errorMap = <Object, AppFailure>{
        SocketException: NetworkFailure('Conexão com o servidor perdida!'),
        DioExceptionType.connectionError: NetworkFailure(
          'Conexão com o servidor perdida!',
        ),
        DioExceptionType.connectionTimeout: NetworkFailure(
          'Tempo de conexão com o servidor esgotado!',
        ),
        DioExceptionType.badResponse: e.response?.statusCode == 401
            ? HttpFailure(
                message: 'Usuário ou senha inválidos!',
                statusCode: e.response?.statusCode,
              )
            : HttpFailure(
                message: e.message,
                error: e.response?.data,
                statusCode: e.response?.statusCode,
              ),
      };

      return errorMap[e.type] ??
          HttpFailure(
            message: e.message,
            error: e.response?.data,
            statusCode: e.response?.statusCode,
          );
    }
    if (e is HttpFailure) {
      return e;
    }
    return HttpFailure();
  }

  @override
  void setHeaders(Map<String, dynamic> header) {
    _dio.options.headers = header;
  }

  @override
  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  @override
  Future<HttpResponseEntity<T>> getImage<T>(String path) async {
    try {
      final String url = path;
      final Response<T> dioResponse = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return HttpResponseEntity<T>(
        data: dioResponse.data,
        statusCode: dioResponse.statusCode ?? 200,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
}
