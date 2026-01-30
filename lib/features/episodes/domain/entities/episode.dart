import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  final int id;
  final String name;
  final int number;
  final String productionCode;

  const Episode({
    required this.id,
    required this.name,
    required this.number,
    required this.productionCode,
  });

  @override
  List<Object?> get props => [id, name, number, productionCode];
}
