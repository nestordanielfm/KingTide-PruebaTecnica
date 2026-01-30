import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/characters/data/datasources/characters_api.dart';
import 'package:template_app/features/characters/domain/entities/characters_page.dart';
import 'package:template_app/features/characters/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersApi charactersApi;

  CharactersRepositoryImpl(this.charactersApi);

  @override
  Future<Either<Failure, CharactersPage>> getCharacters({
    required int page,
    int size = 10,
    String? gender,
    String? status,
    String? species,
  }) async {
    try {
      final response = await charactersApi.getCharacters(
        page: page,
        size: size,
        gender: gender,
        status: status,
        species: species,
      );

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
