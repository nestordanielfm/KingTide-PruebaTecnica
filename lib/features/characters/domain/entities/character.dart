import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String gender;
  final String species;
  final String status;
  final String? imageUrl;

  const Character({
    required this.id,
    required this.name,
    required this.gender,
    required this.species,
    required this.status,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, gender, species, status, imageUrl];
}
