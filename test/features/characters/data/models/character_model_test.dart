import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/features/characters/data/models/character_model.dart';
import 'package:template_app/features/characters/domain/entities/character.dart';

void main() {
  const tCharacterModel = CharacterModel(
    id: 1,
    name: 'Philip J. Fry',
    gender: 'Male',
    species: 'Human',
    status: 'Alive',
    image: 'https://example.com/fry.jpg',
    createdAt: '2023-01-01T00:00:00.000Z',
  );

  group('CharacterModel', () {
    test('should convert from JSON correctly', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'name': 'Philip J. Fry',
        'gender': 'Male',
        'species': 'Human',
        'status': 'Alive',
        'image': 'https://example.com/fry.jpg',
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      // Act
      final result = CharacterModel.fromJson(jsonMap);

      // Assert
      expect(result.id, 1);
      expect(result.name, 'Philip J. Fry');
      expect(result.gender, 'Male');
      expect(result.species, 'Human');
      expect(result.status, 'Alive');
      expect(result.image, 'https://example.com/fry.jpg');
    });

    test('should convert to JSON correctly', () {
      // Act
      final result = tCharacterModel.toJson();

      // Assert
      expect(result['id'], 1);
      expect(result['name'], 'Philip J. Fry');
      expect(result['gender'], 'Male');
      expect(result['species'], 'Human');
      expect(result['status'], 'Alive');
      expect(result['image'], 'https://example.com/fry.jpg');
    });

    test('should convert to entity correctly', () {
      // Act
      final result = tCharacterModel.toEntity();

      // Assert
      expect(result, isA<Character>());
      expect(result.id, 1);
      expect(result.name, 'Philip J. Fry');
      expect(result.gender, 'Male');
      expect(result.species, 'Human');
      expect(result.status, 'Alive');
      expect(result.imageUrl, 'https://example.com/fry.jpg');
    });

    test('should handle null values when converting to entity', () {
      // Arrange
      const modelWithNulls = CharacterModel(
        id: 2,
        name: 'Unknown Character',
        gender: null,
        species: null,
        status: null,
        image: null,
      );

      // Act
      final result = modelWithNulls.toEntity();

      // Assert
      expect(result.gender, 'Unknown');
      expect(result.species, 'Unknown');
      expect(result.status, 'Unknown');
      expect(result.imageUrl, null);
    });
  });
}
