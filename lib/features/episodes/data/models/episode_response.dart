import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/episodes/domain/entities/episode.dart';

part 'episode_response.g.dart';

@JsonSerializable()
class EpisodeResponse {
  final int id;
  final String? name;
  final int number;
  final String? productionCode;

  EpisodeResponse({
    required this.id,
    this.name,
    required this.number,
    this.productionCode,
  });

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeResponseToJson(this);

  Episode toEntity() {
    return Episode(
      id: id,
      name: name ?? 'Unknown Episode',
      number: number,
      productionCode: productionCode ?? 'N/A',
    );
  }
}
