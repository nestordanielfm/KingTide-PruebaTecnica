import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episodes/data/datasources/episodes_api.dart';
import 'package:template_app/features/episodes/data/models/episode_response.dart';
import 'package:template_app/features/episodes/data/models/season_response.dart';
import 'package:template_app/features/episodes/data/models/seasons_page_response.dart';
import 'package:template_app/features/episodes/data/repositories/episodes_repository_impl.dart';

class MockEpisodesApi extends Mock implements EpisodesApi {}

void main() {
  late EpisodesRepositoryImpl repository;
  late MockEpisodesApi mockApi;

  setUp(() {
    mockApi = MockEpisodesApi();
    repository = EpisodesRepositoryImpl(mockApi);
  });

  final tEpisodeResponse = EpisodeResponse(
    id: 1,
    name: 'Space Pilot 3000',
    number: 1,
    productionCode: '1ACV01',
  );

  final tSeasonResponse = SeasonResponse(id: 1, episodes: [tEpisodeResponse]);

  final tResponse = SeasonsPageResponse(
    items: [tSeasonResponse],
    total: 1,
    page: 1,
    size: 10,
    pages: 1,
  );

  group('getSeasons', () {
    test(
      'should return SeasonsPage when the call to API is successful',
      () async {
        // Arrange
        when(
          () => mockApi.getSeasons(any(), any()),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getSeasons(1, 10);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (page) {
          expect(page.items.length, 1);
          expect(page.items.first.id, 1);
          expect(page.page, 1);
          expect(page.pages, 1);
        });
        verify(() => mockApi.getSeasons(1, 10)).called(1);
      },
    );

    test(
      'should return NetworkFailure when there is a connection timeout',
      () async {
        // Arrange
        when(() => mockApi.getSeasons(any(), any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act
        final result = await repository.getSeasons(1, 10);

        // Assert
        expect(result, const Left(NetworkFailure('Connection timeout')));
      },
    );

    test('should return UnauthorizedFailure when status code is 401', () async {
      // Arrange
      when(() => mockApi.getSeasons(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
          ),
        ),
      );

      // Act
      final result = await repository.getSeasons(1, 10);

      // Assert
      expect(result, const Left(UnauthorizedFailure('Unauthorized')));
    });

    test(
      'should return ServerFailure when status code is 500 or higher',
      () async {
        // Arrange
        when(() => mockApi.getSeasons(any(), any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
            ),
          ),
        );

        // Act
        final result = await repository.getSeasons(1, 10);

        // Assert
        expect(result, const Left(ServerFailure('Server error')));
      },
    );

    test('should return ServerFailure for any other exception', () async {
      // Arrange
      when(
        () => mockApi.getSeasons(any(), any()),
      ).thenThrow(Exception('Unknown error'));

      // Act
      final result = await repository.getSeasons(1, 10);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (page) => fail('Should not return success'),
      );
    });
  });
}
