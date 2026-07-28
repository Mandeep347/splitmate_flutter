import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Utility class to map lower-level exceptions into domain-level Failures.
abstract class ErrorMapper {
  /// Converts a generic [Object] (usually caught in repositories) into a [Failure] instance.
  static Failure mapToFailure(Object error) {
    if (error is ServerException) {
      return ServerFailure(error.message, statusCode: error.statusCode);
    } else if (error is NetworkException) {
      return ConnectionFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else if (error is ValidationException) {
      return ValidationFailure(error.message, errors: error.errors);
    } else if (error is DioException) {
      return _mapDioException(error);
    }

    return ServerFailure(error.toString());
  }

  /// Parses [DioException] errors and returns corresponding [Failure] implementations.
  static Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionFailure(
          'Network connection timed out. Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;
        final responseData = response?.data;

        if (responseData is Map<String, dynamic>) {
          final messageVal = responseData['message'];
          final detailVal = responseData['detail'];
          String message = 'A server error occurred. Please try again later.';
          if (messageVal is String) {
            message = messageVal;
          } else if (detailVal is String) {
            message = detailVal;
          } else if (detailVal is List && detailVal.isNotEmpty) {
            final first = detailVal.first;
            if (first is String) {
              message = first;
            } else if (first is Map && first.containsKey('msg')) {
              message = first['msg']?.toString() ?? message;
            } else {
              message = detailVal.toString();
            }
          } else if (detailVal != null) {
            message = detailVal.toString();
          }

          final rawErrors = responseData['errors'] as Map<String, dynamic>?;

          // Handle validation errors (e.g. FastAPI 422 HTTP validation format)
          if (statusCode == 422 && rawErrors != null) {
            final mappedErrors = <String, List<String>>{};
            rawErrors.forEach((key, value) {
              if (value is List) {
                mappedErrors[key] = value.map((e) => e.toString()).toList();
              } else {
                mappedErrors[key] = [value.toString()];
              }
            });
            return ValidationFailure(message, errors: mappedErrors);
          }

          return ServerFailure(message, statusCode: statusCode);
        }

        return ServerFailure(
          'Received invalid server response: ${response?.statusMessage}',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ConnectionFailure('Request was cancelled.');

      case DioExceptionType.connectionError:
      default:
        return const ConnectionFailure(
          'Unable to reach server. Please check your internet connectivity.',
        );
    }
  }
}
