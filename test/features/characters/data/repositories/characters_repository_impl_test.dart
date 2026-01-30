import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/characters/data/datasources/characters_api.dart';
import 'package:template_app/features/characters/data/models/character_model.dart';
import 'package:template_app/features/characters/data/models/characters_page_response.dart';
import 'package:template_app/features/characters/data/repositories/characters_repository_impl.dart';

class MockCharactersApi extends Mock implements CharactersApi {}

void main() {
  late CharactersRepositoryImpl repository;
  late MockCharactersApi mockApi;

  setUp(() {
    mockApi = MockCharactersApi();
    repository = CharactersRepositoryImpl(mockApi);
  });

  const tCharacterModel = CharacterModel(
    id: 1,
    name: 'Philip J. Fry',
    gender: 'Male',
    species: 'Human',
    status: 'Alive',
    image: 'https://example.com/fry.jpg',
  );

  const tResponse = CharactersPageResponse(
    items: [tCharacterModel],
    total: 100,
    page: 1,
    size: 10,
    pages: 10,
  );

  group('getCharacters', () {
    test(
      'should return CharactersPage when the call to API is successful',
      () async {
        // Arrange
        when(
          () => mockApi.getCharacters(
            page: any(named: 'page'),
            size: any(named: 'size'),
            gender: any(named: 'gender'),
            status: any(named: 'status'),
            species: any(named: 'species'),
          ),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not return failure'), (page) {
          expect(page.characters.length, 1);
          expect(page.characters.first.name, 'Philip J. Fry');
          expect(page.page, 1);
          expect(page.totalPages, 10);
        });
        verify(
          () => mockApi.getCharacters(
            page: 1,
            size: 10,
            gender: null,
            status: null,
            species: null,
          ),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure when there is a connection timeout',
      () async {
        // Arrange
        when(
          () => mockApi.getCharacters(
            page: any(named: 'page'),
            size: any(named: 'size'),
            gender: any(named: 'gender'),
            status: any(named: 'status'),
            species: any(named: 'species'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result, const Left(NetworkFailure('Connection timeout')));
      },
    );

    test('should return UnauthorizedFailure when status code is 401', () async {
      // Arrange
      when(
        () => mockApi.getCharacters(
          page: any(named: 'page'),
          size: any(named: 'size'),
          gender: any(named: 'gender'),
          status: any(named: 'status'),
          species: any(named: 'species'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
          ),
        ),
      );

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      expect(result, const Left(UnauthorizedFailure('Unauthorized')));
    });

    test(
      'should return ServerFailure when status code is 500 or higher',
      () async {
        // Arrange
        when(
          () => mockApi.getCharacters(
            page: any(named: 'page'),
            size: any(named: 'size'),
            gender: any(named: 'gender'),
            status: any(named: 'status'),
            species: any(named: 'species'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
            ),
          ),
        );

        // Act
        final result = await repository.getCharacters(page: 1);

        // Assert
        expect(result, const Left(ServerFailure('Server error')));
      },
    );

    test('should return ServerFailure for any other exception', () async {
      // Arrange
      when(
        () => mockApi.getCharacters(
          page: any(named: 'page'),
          size: any(named: 'size'),
          gender: any(named: 'gender'),
          status: any(named: 'status'),
          species: any(named: 'species'),
        ),
      ).thenThrow(Exception('Unknown error'));

      // Act
      final result = await repository.getCharacters(page: 1);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (page) => fail('Should not return success'),
      );
    });
  });
}
