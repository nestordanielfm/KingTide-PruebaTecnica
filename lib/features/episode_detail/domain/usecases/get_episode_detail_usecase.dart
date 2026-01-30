import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';
import 'package:template_app/features/episode_detail/domain/repositories/episode_detail_repository.dart';

class GetEpisodeDetailUseCase {
  final EpisodeDetailRepository repository;

  GetEpisodeDetailUseCase(this.repository);

  Future<Either<Failure, EpisodeDetail>> call(
    EpisodeDetailParams params,
  ) async {
    return await repository.getEpisodeDetail(
      season: params.season,
      episode: params.episode,
    );
  }
}

class EpisodeDetailParams extends Equatable {
  final int season;
  final int episode;

  const EpisodeDetailParams({required this.season, required this.episode});

  @override
  List<Object> get props => [season, episode];
}
