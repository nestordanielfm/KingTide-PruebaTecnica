import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/characters/data/models/character_model.dart';
import 'package:template_app/features/characters/domain/entities/characters_page.dart';

part 'characters_page_response.g.dart';

@JsonSerializable()
class CharactersPageResponse {
  final List<CharacterModel> items;
  final int total;
  final int page;
  final int size;
  final int pages;

  const CharactersPageResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory CharactersPageResponse.fromJson(Map<String, dynamic> json) =>
      _$CharactersPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersPageResponseToJson(this);

  CharactersPage toEntity() {
    return CharactersPage(
      characters: items.map((model) => model.toEntity()).toList(),
      page: page,
      totalPages: pages,
    );
  }
}
