import 'package:mobx/mobx.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';
import 'package:template_app/features/episode_detail/domain/usecases/get_episode_detail_usecase.dart';

part 'episode_detail_store.g.dart';

class EpisodeDetailStore = _EpisodeDetailStore with _$EpisodeDetailStore;

abstract class _EpisodeDetailStore with Store {
  final GetEpisodeDetailUseCase getEpisodeDetailUseCase;

  _EpisodeDetailStore(this.getEpisodeDetailUseCase);

  @observable
  bool isLoading = false;

  @observable
  EpisodeDetail? episodeDetail;

  @observable
  String? errorMessage;

  @action
  Future<void> loadEpisodeDetail(int season, int episode) async {
    isLoading = true;
    errorMessage = null;

    final result = await getEpisodeDetailUseCase(
      EpisodeDetailParams(season: season, episode: episode),
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        isLoading = false;
      },
      (detail) {
        episodeDetail = detail;
        isLoading = false;
      },
    );
  }
}
