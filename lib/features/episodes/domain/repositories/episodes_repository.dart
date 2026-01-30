import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episodes/domain/entities/seasons_page.dart';

abstract class EpisodesRepository {
  Future<Either<Failure, SeasonsPage>> getSeasons(int page, int size);
}
