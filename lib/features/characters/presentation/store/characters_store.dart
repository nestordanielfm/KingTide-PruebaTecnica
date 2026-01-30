import 'package:mobx/mobx.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/characters/domain/entities/character.dart';
import 'package:template_app/features/characters/domain/usecases/get_characters_usecase.dart';

part 'characters_store.g.dart';

class CharactersStore = _CharactersStore with _$CharactersStore;

abstract class _CharactersStore with Store {
  final GetCharactersUseCase getCharactersUseCase;

  _CharactersStore(this.getCharactersUseCase);

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingMore = false;

  @observable
  List<Character> characters = [];

  @observable
  Failure? failure;

  @observable
  int currentPage = 0;

  @observable
  int totalPages = 0;

  // Filters
  @observable
  String? selectedGender;

  @observable
  String? selectedStatus;

  @observable
  String? selectedSpecies;

  @computed
  bool get isError => failure != null;

  @computed
  bool get hasMore => currentPage < totalPages;

  @computed
  bool get isEmpty => characters.isEmpty && !isLoading;

  @computed
  bool get hasActiveFilters =>
      selectedGender != null ||
      selectedStatus != null ||
      selectedSpecies != null;

  @action
  void setGenderFilter(String? gender) {
    selectedGender = gender;
    _resetAndLoad();
  }

  @action
  void setStatusFilter(String? status) {
    selectedStatus = status;
    _resetAndLoad();
  }

  @action
  void setSpeciesFilter(String? species) {
    selectedSpecies = species;
    _resetAndLoad();
  }

  @action
  void clearFilters() {
    selectedGender = null;
    selectedStatus = null;
    selectedSpecies = null;
    _resetAndLoad();
  }

  @action
  Future<void> loadCharacters() async {
    if (isLoading || isLoadingMore) return;

    isLoading = true;
    failure = null;
    currentPage = 0;
    characters = [];

    await _fetchCharacters(1);
    isLoading = false;
  }

  @action
  Future<void> loadMoreCharacters() async {
    if (isLoadingMore || !hasMore || isLoading) return;

    isLoadingMore = true;
    await _fetchCharacters(currentPage + 1);
    isLoadingMore = false;
  }

  Future<void> _resetAndLoad() async {
    currentPage = 0;
    characters = [];
    await loadCharacters();
  }

  Future<void> _fetchCharacters(int page) async {
    final result = await getCharactersUseCase(
      CharactersParams(
        page: page,
        size: 10,
        gender: selectedGender,
        status: selectedStatus,
        species: selectedSpecies,
      ),
    );

    result.fold(
      (fail) {
        failure = fail;
      },
      (charactersPage) {
        characters = [...characters, ...charactersPage.characters];
        currentPage = charactersPage.page;
        totalPages = charactersPage.totalPages;
      },
    );
  }

  @action
  void reset() {
    isLoading = false;
    isLoadingMore = false;
    characters = [];
    failure = null;
    currentPage = 0;
    totalPages = 0;
    selectedGender = null;
    selectedStatus = null;
    selectedSpecies = null;
  }
}
