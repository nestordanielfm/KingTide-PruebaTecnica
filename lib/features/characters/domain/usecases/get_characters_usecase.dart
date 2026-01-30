import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/characters/domain/entities/characters_page.dart';
import 'package:template_app/features/characters/domain/repositories/characters_repository.dart';

class GetCharactersUseCase {
  final CharactersRepository repository;

  GetCharactersUseCase(this.repository);

  Future<Either<Failure, CharactersPage>> call(CharactersParams params) async {
    return await repository.getCharacters(
      page: params.page,
      size: params.size,
      gender: params.gender,
      status: params.status,
      species: params.species,
    );
  }
}

class CharactersParams extends Equatable {
  final int page;
  final int size;
  final String? gender;
  final String? status;
  final String? species;

  const CharactersParams({
    required this.page,
    this.size = 10,
    this.gender,
    this.status,
    this.species,
  });

  @override
  List<Object?> get props => [page, size, gender, status, species];
}
