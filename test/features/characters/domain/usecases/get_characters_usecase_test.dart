import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/features/characters/domain/entities/character.dart';
import 'package:template_app/features/characters/domain/entities/characters_page.dart';
import 'package:template_app/features/characters/domain/repositories/characters_repository.dart';
import 'package:template_app/features/characters/domain/usecases/get_characters_usecase.dart';

class MockCharactersRepository extends Mock implements CharactersRepository {}

void main() {
  late GetCharactersUseCase useCase;
  late MockCharactersRepository mockRepository;

  setUp(() {
    mockRepository = MockCharactersRepository();
    useCase = GetCharactersUseCase(mockRepository);
  });

  const tCharacter = Character(
    id: 1,
    name: 'Philip J. Fry',
    gender: 'Male',
    species: 'Human',
    status: 'Alive',
    imageUrl: 'https://example.com/fry.jpg',
  );

  const tCharactersPage = CharactersPage(
    characters: [tCharacter],
    page: 1,
    totalPages: 10,
  );

  const tParams = CharactersParams(page: 1, size: 10);

  test('should get characters from the repository', () async {
    // Arrange
    when(
      () => mockRepository.getCharacters(
        page: any(named: 'page'),
        size: any(named: 'size'),
        gender: any(named: 'gender'),
        status: any(named: 'status'),
        species: any(named: 'species'),
      ),
    ).thenAnswer((_) async => const Right(tCharactersPage));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Right(tCharactersPage));
    verify(
      () => mockRepository.getCharacters(
        page: 1,
        size: 10,
        gender: null,
        status: null,
        species: null,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pass correct filters to repository', () async {
    // Arrange
    const tParamsWithFilters = CharactersParams(
      page: 2,
      size: 20,
      gender: 'Male',
      status: 'Alive',
      species: 'Human',
    );

    when(
      () => mockRepository.getCharacters(
        page: any(named: 'page'),
        size: any(named: 'size'),
        gender: any(named: 'gender'),
        status: any(named: 'status'),
        species: any(named: 'species'),
      ),
    ).thenAnswer((_) async => const Right(tCharactersPage));

    // Act
    await useCase(tParamsWithFilters);

    // Assert
    verify(
      () => mockRepository.getCharacters(
        page: 2,
        size: 20,
        gender: 'Male',
        status: 'Alive',
        species: 'Human',
      ),
    ).called(1);
  });
}
