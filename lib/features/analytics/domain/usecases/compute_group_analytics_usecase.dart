import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import '../entities/group_analytics.dart';
import '../repositories/i_analytics_repository.dart';

/// Usecase returning group analytics metrics fetched from the remote endpoint.
class ComputeGroupAnalyticsUseCase {
  /// The analytics repository interface.
  final IAnalyticsRepository repository;

  /// Creates a const [ComputeGroupAnalyticsUseCase] instance.
  const ComputeGroupAnalyticsUseCase({required this.repository});

  /// Executes the usecase.
  /// Throws [Failure] subclass on error.
  Future<GroupAnalytics> call({
    required String groupId,
    required String currency,
  }) async {
    try {
      return await repository.getGroupAnalytics(groupId);
    } on Failure {
      rethrow;
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on NetworkClientException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw UnknownFailure(e.toString());
    }
  }
}
