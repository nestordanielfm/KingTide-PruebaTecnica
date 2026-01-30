import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/features/episodes/domain/entities/episode.dart';
import 'package:template_app/features/episodes/domain/entities/season.dart';
import 'package:template_app/features/episodes/domain/entities/seasons_page.dart';
import 'package:template_app/features/episodes/domain/repositories/episodes_repository.dart';
import 'package:template_app/features/episodes/domain/usecases/get_seasons_usecase.dart';

class MockEpisodesRepository extends Mock implements EpisodesRepository {}

void main() {
  late GetSeasonsUseCase useCase;
  late MockEpisodesRepository mockRepository;

  setUp(() {
    mockRepository = MockEpisodesRepository();
    useCase = GetSeasonsUseCase(mockRepository);
  });

  const tEpisode = Episode(
    id: 1,
    name: 'Space Pilot 3000',
    number: 1,
    productionCode: '1ACV01',
  );

  const tSeason = Season(id: 1, episodes: [tEpisode]);

  const tSeasonsPage = SeasonsPage(
    items: [tSeason],
    total: 1,
    page: 1,
    size: 10,
    pages: 1,
  );

  const tParams = SeasonsParams(page: 1);

  test('should get seasons from the repository', () async {
    // Arrange
    when(
      () => mockRepository.getSeasons(any(), any()),
    ).thenAnswer((_) async => const Right(tSeasonsPage));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Right(tSeasonsPage));
    verify(() => mockRepository.getSeasons(1, 1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pass custom size parameter to repository', () async {
    // Arrange
    const tParamsWithSize = SeasonsParams(page: 2, size: 20);

    when(
      () => mockRepository.getSeasons(any(), any()),
    ).thenAnswer((_) async => const Right(tSeasonsPage));

    // Act
    await useCase(tParamsWithSize);

    // Assert
    verify(() => mockRepository.getSeasons(2, 20)).called(1);
  });
}
