import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/characters/domain/entities/characters_page.dart';

abstract class CharactersRepository {
  Future<Either<Failure, CharactersPage>> getCharacters({
    required int page,
    int size = 10,
    String? gender,
    String? status,
    String? species,
  });
}
