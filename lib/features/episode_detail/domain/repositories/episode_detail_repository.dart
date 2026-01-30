import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';

abstract class EpisodeDetailRepository {
  Future<Either<Failure, EpisodeDetail>> getEpisodeDetail({
    required int season,
    required int episode,
  });
}
