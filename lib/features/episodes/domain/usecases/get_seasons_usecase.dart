import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episodes/domain/entities/seasons_page.dart';
import 'package:template_app/features/episodes/domain/repositories/episodes_repository.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class GetSeasonsUseCase implements UseCase<SeasonsPage, SeasonsParams> {
  final EpisodesRepository repository;

  GetSeasonsUseCase(this.repository);

  @override
  Future<Either<Failure, SeasonsPage>> call(SeasonsParams params) async {
    return await repository.getSeasons(params.page, params.size);
  }
}

class SeasonsParams extends Equatable {
  final int page;
  final int size;

  const SeasonsParams({this.page = 1, this.size = 1});

  @override
  List<Object> get props => [page, size];
}
