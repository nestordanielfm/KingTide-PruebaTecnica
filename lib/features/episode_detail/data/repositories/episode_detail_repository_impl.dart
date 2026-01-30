import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/config/environment.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episode_detail/data/datasources/omdb_api.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';
import 'package:template_app/features/episode_detail/domain/repositories/episode_detail_repository.dart';

class EpisodeDetailRepositoryImpl implements EpisodeDetailRepository {
  final OmdbApi omdbApi;

  EpisodeDetailRepositoryImpl(this.omdbApi);

  @override
  Future<Either<Failure, EpisodeDetail>> getEpisodeDetail({
    required int season,
    required int episode,
  }) async {
    try {
      final response = await omdbApi.getEpisodeDetail(
        apiKey: EnvironmentConfig.omdbApiKey,
        title: 'Futurama',
        season: season,
        episode: episode,
      );

      // Check if the API returned an error response
      if (response.response == 'False') {
        return const Left(ServerFailure('Episode not found'));
      }

      return Right(response.toEntity());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure('Invalid API key'));
      }
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        return const Left(ServerFailure('Server error'));
      }
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
