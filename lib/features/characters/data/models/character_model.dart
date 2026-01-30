import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/characters/domain/entities/character.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  final int id;
  final String name;
  final String? gender;
  final String? species;
  final String? status;
  final String? createdAt;
  final String? image;

  const CharacterModel({
    required this.id,
    required this.name,
    this.gender,
    this.species,
    this.status,
    this.createdAt,
    this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      gender: gender ?? 'Unknown',
      species: species ?? 'Unknown',
      status: status ?? 'Unknown',
      imageUrl: image,
    );
  }
}
