import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episodes/data/datasources/episodes_api.dart';
import 'package:template_app/features/episodes/domain/entities/seasons_page.dart';
import 'package:template_app/features/episodes/domain/repositories/episodes_repository.dart';

class EpisodesRepositoryImpl implements EpisodesRepository {
  final EpisodesApi episodesApi;

  EpisodesRepositoryImpl(this.episodesApi);

  @override
  Future<Either<Failure, SeasonsPage>> getSeasons(int page, int size) async {
    try {
      final response = await episodesApi.getSeasons(page, size);
      return Right(response.toEntity());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure('Unauthorized'));
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
