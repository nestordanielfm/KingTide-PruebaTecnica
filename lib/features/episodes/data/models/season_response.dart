import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/episodes/data/models/episode_response.dart';
import 'package:template_app/features/episodes/domain/entities/season.dart';

part 'season_response.g.dart';

@JsonSerializable()
class SeasonResponse {
  final int id;
  final List<EpisodeResponse> episodes;

  SeasonResponse({required this.id, required this.episodes});

  factory SeasonResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonResponseToJson(this);

  Season toEntity() {
    // Sort episodes by episode number
    final sortedEpisodes = episodes.map((e) => e.toEntity()).toList()
      ..sort((a, b) => a.number.compareTo(b.number));

    return Season(id: id, episodes: sortedEpisodes);
  }
}
