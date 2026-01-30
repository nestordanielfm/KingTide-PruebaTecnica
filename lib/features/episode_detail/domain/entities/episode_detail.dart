import 'package:equatable/equatable.dart';

class EpisodeDetail extends Equatable {
  final String title;
  final String year;
  final String rated;
  final String released;
  final int season;
  final int episode;
  final String runtime;
  final List<String> genre;
  final String director;
  final String writer;
  final List<String> actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final List<String> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbId;
  final String? seriesId;

  const EpisodeDetail({
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
  });

  @override
  List<Object?> get props => [
    title,
    year,
    rated,
    released,
    season,
    episode,
    runtime,
    genre,
    director,
    writer,
    actors,
    plot,
    language,
    country,
    awards,
    poster,
    ratings,
    metascore,
    imdbRating,
    imdbVotes,
    imdbId,
    seriesId,
  ];
}
