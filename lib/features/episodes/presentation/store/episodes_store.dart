import 'package:mobx/mobx.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/episodes/domain/entities/season.dart';
import 'package:template_app/features/episodes/domain/usecases/get_seasons_usecase.dart';

part 'episodes_store.g.dart';

class EpisodesStore = _EpisodesStore with _$EpisodesStore;

abstract class _EpisodesStore with Store {
  final GetSeasonsUseCase getSeasonsUseCase;

  _EpisodesStore(this.getSeasonsUseCase);

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingMore = false;

  @observable
  List<Season> seasons = [];

  @observable
  Failure? failure;

  @observable
  int currentPage = 0;

  @observable
  int totalPages = 0;

  @computed
  bool get isError => failure != null;

  @computed
  bool get hasMore => currentPage < totalPages;

  @computed
  bool get isEmpty => seasons.isEmpty && !isLoading;

  @action
  Future<void> loadSeasons() async {
    if (isLoading || isLoadingMore) return;
    
    isLoading = true;
    failure = null;
    currentPage = 0;
    seasons = [];

    await _fetchSeasons(1);
    isLoading = false;
  }

  @action
  Future<void> loadMoreSeasons() async {
    if (isLoadingMore || !hasMore || isLoading) return;

    isLoadingMore = true;
    await _fetchSeasons(currentPage + 1);
    isLoadingMore = false;
  }

  Future<void> _fetchSeasons(int page) async {
    final result = await getSeasonsUseCase(SeasonsParams(page: page, size: 1));

    result.fold(
      (fail) {
        failure = fail;
      },
      (seasonsPage) {
        seasons = [...seasons, ...seasonsPage.items];
        currentPage = seasonsPage.page;
        totalPages = seasonsPage.pages;
      },
    );
  }

  @action
  void reset() {
    isLoading = false;
    isLoadingMore = false;
    seasons = [];
    failure = null;
    currentPage = 0;
    totalPages = 0;
  }
}
