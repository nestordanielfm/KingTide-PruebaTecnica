import 'package:equatable/equatable.dart';
import 'package:template_app/features/characters/domain/entities/character.dart';

class CharactersPage extends Equatable {
  final List<Character> characters;
  final int page;
  final int totalPages;

  const CharactersPage({
    required this.characters,
    required this.page,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [characters, page, totalPages];
}
