import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/episode_detail/data/models/rating_model.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';

part 'episode_detail_model.g.dart';

@JsonSerializable()
class EpisodeDetailModel {
  @JsonKey(name: 'Title')
  final String title;

  @JsonKey(name: 'Year')
  final String year;

  @JsonKey(name: 'Rated')
  final String rated;

  @JsonKey(name: 'Released')
  final String released;

  @JsonKey(name: 'Season')
  final String season;

  @JsonKey(name: 'Episode')
  final String episode;

  @JsonKey(name: 'Runtime')
  final String runtime;

  @JsonKey(name: 'Genre')
  final String genre;

  @JsonKey(name: 'Director')
  final String director;

  @JsonKey(name: 'Writer')
  final String writer;

  @JsonKey(name: 'Actors')
  final String actors;

  @JsonKey(name: 'Plot')
  final String plot;

  @JsonKey(name: 'Language')
  final String language;

  @JsonKey(name: 'Country')
  final String country;

  @JsonKey(name: 'Awards')
  final String awards;

  @JsonKey(name: 'Poster')
  final String poster;

  @JsonKey(name: 'Ratings')
  final List<RatingModel> ratings;

  @JsonKey(name: 'Metascore')
  final String metascore;

  @JsonKey(name: 'imdbRating')
  final String imdbRating;

  @JsonKey(name: 'imdbVotes')
  final String imdbVotes;

  @JsonKey(name: 'imdbID')
  final String imdbId;

  @JsonKey(name: 'seriesID')
  final String? seriesId;

  @JsonKey(name: 'Type')
  final String type;

  @JsonKey(name: 'Response')
  final String response;

  const EpisodeDetailModel({
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.season,
    required this.episode,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.imdbId,
    this.seriesId,
    required this.type,
    required this.response,
  });

  factory EpisodeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeDetailModelToJson(this);

  EpisodeDetail toEntity() {
    return EpisodeDetail(
      title: title,
      year: year,
      rated: rated,
      released: released,
      season: int.tryParse(season) ?? 0,
      episode: int.tryParse(episode) ?? 0,
      runtime: runtime,
      genre: genre.split(', '),
      director: director,
      writer: writer,
      actors: actors.split(', '),
      plot: plot,
      language: language,
      country: country,
      awards: awards,
      poster: poster,
      ratings: ratings.map((r) => '${r.source}: ${r.value}').toList(),
      metascore: metascore,
      imdbRating: imdbRating,
      imdbVotes: imdbVotes,
      imdbId: imdbId,
      seriesId: seriesId,
    );
  }
}
