import 'package:equatable/equatable.dart';
import 'package:template_app/features/episodes/domain/entities/episode.dart';

class Season extends Equatable {
  final int id;
  final List<Episode> episodes;

  const Season({
    required this.id,
    required this.episodes,
  });

  @override
  List<Object?> get props => [id, episodes];
}
