import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:template_app/core/config/environment.dart';
import 'package:template_app/core/network/dio_client.dart';
import 'package:template_app/features/characters/data/datasources/characters_api.dart';
import 'package:template_app/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:template_app/features/characters/domain/repositories/characters_repository.dart';
import 'package:template_app/features/characters/domain/usecases/get_characters_usecase.dart';
import 'package:template_app/features/characters/presentation/store/characters_store.dart';
import 'package:template_app/features/episode_detail/data/datasources/omdb_api.dart';
import 'package:template_app/features/episode_detail/data/repositories/episode_detail_repository_impl.dart';
import 'package:template_app/features/episode_detail/domain/repositories/episode_detail_repository.dart';
import 'package:template_app/features/episode_detail/domain/usecases/get_episode_detail_usecase.dart';
import 'package:template_app/features/episode_detail/presentation/store/episode_detail_store.dart';
import 'package:template_app/features/episodes/data/datasources/episodes_api.dart';
import 'package:template_app/features/episodes/data/repositories/episodes_repository_impl.dart';
import 'package:template_app/features/episodes/domain/repositories/episodes_repository.dart';
import 'package:template_app/features/episodes/domain/usecases/get_seasons_usecase.dart';
import 'package:template_app/features/episodes/presentation/store/episodes_store.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  // Episodes feature
  getIt.registerLazySingleton<EpisodesApi>(
    () => EpisodesApi(getIt<Dio>(), baseUrl: EnvironmentConfig.futuramaApiUrl),
  );
  getIt.registerLazySingleton<EpisodesRepository>(
    () => EpisodesRepositoryImpl(getIt<EpisodesApi>()),
  );
  getIt.registerLazySingleton<GetSeasonsUseCase>(
    () => GetSeasonsUseCase(getIt<EpisodesRepository>()),
  );
  getIt.registerFactory<EpisodesStore>(
    () => EpisodesStore(getIt<GetSeasonsUseCase>()),
  );

  // Episode Detail feature
  getIt.registerLazySingleton<OmdbApi>(
    () => OmdbApi(getIt<Dio>(), baseUrl: EnvironmentConfig.omdbApiUrl),
  );
  getIt.registerLazySingleton<EpisodeDetailRepository>(
    () => EpisodeDetailRepositoryImpl(getIt<OmdbApi>()),
  );
  getIt.registerLazySingleton<GetEpisodeDetailUseCase>(
    () => GetEpisodeDetailUseCase(getIt<EpisodeDetailRepository>()),
  );
  getIt.registerFactory<EpisodeDetailStore>(
    () => EpisodeDetailStore(getIt<GetEpisodeDetailUseCase>()),
  );

  // Characters feature
  getIt.registerLazySingleton<CharactersApi>(
    () =>
        CharactersApi(getIt<Dio>(), baseUrl: EnvironmentConfig.futuramaApiUrl),
  );
  getIt.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(getIt<CharactersApi>()),
  );
  getIt.registerLazySingleton<GetCharactersUseCase>(
    () => GetCharactersUseCase(getIt<CharactersRepository>()),
  );
  getIt.registerFactory<CharactersStore>(
    () => CharactersStore(getIt<GetCharactersUseCase>()),
  );
}
