import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splito_flutter/core/error/error_mapper.dart';
import 'package:splito_flutter/core/error/failures.dart';

void main() {
  group('ErrorMapper.mapToFailure', () {
    test('maps String detail response correctly', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {'detail': 'Group not found.'},
        ),
      );

      final failure = ErrorMapper.mapToFailure(dioError);
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Group not found.');
    });

    test('maps List of String detail response correctly', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
          data: {
            'detail': ['First group not found.', 'Second detail.'],
          },
        ),
      );

      final failure = ErrorMapper.mapToFailure(dioError);
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'First group not found.');
    });

    test(
      'maps List of Map detail response (FastAPI validation format) correctly',
      () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 422,
            data: {
              'detail': [
                {
                  'loc': ['body', 'title'],
                  'msg': 'Field title is required.',
                  'type': 'value_error.missing',
                },
              ],
            },
          ),
        );

        final failure = ErrorMapper.mapToFailure(dioError);
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Field title is required.');
      },
    );

    test('maps fallback message when detail is missing or null', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: <String, dynamic>{},
        ),
      );

      final failure = ErrorMapper.mapToFailure(dioError);
      expect(failure, isA<ServerFailure>());
      expect(
        failure.message,
        'A server error occurred. Please try again later.',
      );
    });
  });
}
