# Copilot Instructions for KingTide-PruebaTecnica

## Project Overview

This is a **Flutter mobile application** called "Futurama App" — a Futurama-themed TV series browser that displays episodes and characters from the Futurama API and OMDB API. The app targets both Android and iOS.

---

## Tech Stack

| Category | Technology |
|---|---|
| Language | Dart 3.9.2+ (full null safety) |
| Framework | Flutter (Material Design 3) |
| State Management | MobX (`mobx`, `flutter_mobx`) |
| Navigation | AutoRoute (`auto_route`) — code-generated |
| HTTP Client | Dio + Retrofit — code-generated REST clients |
| Dependency Injection | GetIt service locator |
| Error Handling | Dartz `Either<Failure, Success>` |
| Value Equality | Equatable |
| JSON Serialization | `json_serializable` — code-generated |
| Environment Config | `flutter_dotenv` (`.env`, `.env.dev`, `.env.prod`) |
| Loading UI | `shimmer` |
| Testing | `flutter_test` + `mocktail` |
| Code Generation | `build_runner` |

---

## Architecture

The project strictly follows **Clean Architecture** with a **feature-based** directory layout.

### Feature Layer Structure

Every feature (`episodes`, `characters`, `episode_detail`, `main`) is organized as:

```
lib/features/<feature>/
├── presentation/
│   ├── pages/         # Flutter screens (@RoutePage annotated)
│   ├── store/         # MobX stores (@observable, @action, @computed)
│   └── widgets/       # Reusable UI components
├── domain/
│   ├── entities/      # Pure Dart objects (business data)
│   ├── repositories/  # Abstract repository interfaces
│   └── usecases/      # Single-responsibility use cases
└── data/
    ├── datasources/   # Retrofit API clients
    ├── models/        # JSON-serializable data models
    └── repositories/  # Concrete repository implementations
```

### Cross-Cutting Concerns

```
lib/core/
├── config/     # AppConfig (reads from .env via flutter_dotenv)
├── error/      # Exceptions and Failure types
├── network/    # Dio client setup with interceptors
├── router/     # AutoRoute configuration (app_router.dart + app_router.gr.dart)
└── theme/      # AppTheme and AppColors

lib/injection/  # GetIt dependency injection setup (injection.dart)
lib/main.dart   # App entry point
```

### Data Flow

```
Page (UI) → Store (MobX) → UseCase → Repository Interface
                                          ↓
                                 Repository Impl → API Datasource (Retrofit/Dio)
```

Error responses use `Either<Failure, T>`. Repositories catch `DioException` / `Exception` and map them to domain `Failure` subclasses (`ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `CacheFailure`).

---

## Code Generation

Several tools require running `build_runner` to regenerate `.g.dart` files. **Always run code generation after modifying:**

- MobX store files (`*.dart` containing `@observable`, `@action`) → generates `*.g.dart`
- Retrofit API clients (`@RestApi`) → generates `*.g.dart`
- AutoRoute configuration (`@AutoRouterConfig`) → generates `app_router.gr.dart`
- JSON model classes (`@JsonSerializable`) → generates `*.g.dart`

**Command:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For watch mode during development:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

> **Note:** Generated `*.g.dart` files are `.gitignore`d. They are not committed, so you must run `build_runner` after cloning or modifying annotated code.

---

## Commands

### Setup
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run
```bash
flutter run                        # development (default .env)
flutter run --dart-define=ENV=dev  # explicit dev env
flutter run --dart-define=ENV=prod # production env
```

### Lint & Analyze
```bash
flutter analyze         # static analysis
dart format lib/ test/  # format code
```

### Test
```bash
flutter test                    # run all tests
flutter test --coverage         # with coverage report
flutter test <path/to/test.dart> # single test file
```

### Build
```bash
flutter build apk --release     # Android APK
flutter build ios --release     # iOS
```

---

## Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Classes | PascalCase | `CharactersPage`, `EpisodesStore` |
| Files | snake_case | `characters_page.dart`, `episodes_store.dart` |
| Variables & methods | camelCase | `isLoading`, `fetchCharacters()` |
| Private members | `_` prefix | `_dio`, `_fetchData()` |
| Domain entities | no suffix | `Character`, `Season`, `Episode` |
| Data models | `Model` suffix | `CharacterModel`, `SeasonModel` |
| API response wrappers | `Response` suffix | `CharactersResponse`, `SeasonsResponse` |
| Paginated collections | `Page`/`Pages` suffix | `CharacterPages`, `SeasonPage` |
| Use cases | `UseCase` suffix | `GetCharactersUseCase`, `GetSeasonsUseCase` |
| MobX stores | `Store` suffix | `CharactersStore`, `EpisodesStore` |
| Retrofit clients | `Api` suffix | `CharactersApi`, `EpisodesApi` |

---

## Adding a New Feature

Follow this checklist when adding a feature:

1. **Domain layer first:**
   - Create entity in `domain/entities/`
   - Create abstract repository interface in `domain/repositories/`
   - Create use case in `domain/usecases/` (one class per operation)
   - Use case `call()` returns `Future<Either<Failure, T>>`
   - Use `Equatable` for parameters classes

2. **Data layer:**
   - Create Retrofit API client in `data/datasources/` with `@RestApi` annotation
   - Create JSON models in `data/models/` with `@JsonSerializable` annotation; add `fromJson`/`toJson`
   - Implement abstract repository in `data/repositories/`, catching `DioException` → `Failure`

3. **Presentation layer:**
   - Create MobX store in `presentation/store/`; add `@observable`, `@action`, `@computed`
   - Create page in `presentation/pages/` with `@RoutePage()` annotation
   - Add route to `lib/core/router/app_router.dart`
   - Create reusable widgets in `presentation/widgets/`

4. **Dependency injection:**
   - Register datasource, repository, use case, and store in `lib/injection/injection.dart`
   - Repositories and use cases → `registerLazySingleton`
   - MobX stores → `registerFactory` (new instance per navigation)

5. **Run code generation** after steps above.

---

## Dependency Injection Pattern

GetIt is configured in `lib/injection/injection.dart`. Registration pattern:

```dart
// Datasource (lazy singleton)
getIt.registerLazySingleton<MyApi>(() => MyApi(getIt<Dio>()));

// Repository (lazy singleton)
getIt.registerLazySingleton<MyRepository>(() => MyRepositoryImpl(getIt<MyApi>()));

// UseCase (lazy singleton)
getIt.registerLazySingleton<GetMyDataUseCase>(() => GetMyDataUseCase(getIt<MyRepository>()));

// Store (factory — fresh instance per screen)
getIt.registerFactory<MyStore>(() => MyStore(getIt<GetMyDataUseCase>()));
```

Pages retrieve their store via `getIt<MyStore>()` at construction time.

---

## State Management Pattern (MobX)

Stores follow this pattern:

```dart
part 'my_store.g.dart'; // generated file

class MyStore = _MyStoreBase with _$MyStore;

abstract class _MyStoreBase with Store {
  @observable
  ObservableList<Item> items = ObservableList<Item>();

  @observable
  bool isLoading = false;

  @computed
  bool get isEmpty => !isLoading && items.isEmpty;

  @action
  Future<void> fetchItems() async {
    isLoading = true;
    final result = await _useCase(Params(...));
    result.fold(
      (failure) { /* handle error */ },
      (data) { items.addAll(data); },
    );
    isLoading = false;
  }
}
```

Wrap reactive UI in `Observer(builder: (context) => ...)` widgets.

---

## Error Handling

All data layer operations return `Either<Failure, T>`:

```dart
try {
  final result = await _api.getData();
  return Right(result.toEntity());
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    return Left(NetworkFailure());
  }
  return Left(ServerFailure());
} catch (e) {
  return Left(ServerFailure());
}
```

Failure types: `ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `CacheFailure`.

---

## External APIs

| API | URL | Purpose | Key |
|---|---|---|---|
| Futurama API | `https://futuramaapi.com/api` | Episodes, Characters | None required |
| OMDB API | `http://www.omdbapi.com` | Episode detail (IMDb data) | `OMDB_API_KEY` in `.env` |

API base URLs and keys are loaded from environment files via `AppConfig`:
- `AppConfig.futuramaApiUrl`
- `AppConfig.omdbApiUrl`
- `AppConfig.omdbApiKey`

---

## Environment Configuration

Three environment files are present (committed to repository):

| File | Purpose |
|---|---|
| `.env` | Default (development) |
| `.env.dev` | Development overrides |
| `.env.prod` | Production overrides |

`AppConfig` in `lib/core/config/` reads values from dotenv. All Dio clients are instantiated through `lib/core/network/` using these config values.

> ⚠️ **Known issue:** The OMDB API key (`d93c3aa9`) is committed in plain text in the `.env` files. This should be rotated and moved to a secrets manager in a real production environment.

---

## Routing

Navigation uses `AutoRoute`. Routes are defined in `lib/core/router/app_router.dart`. After adding a new `@RoutePage()`, re-run code generation to update `app_router.gr.dart`.

Navigate using `context.router.push(MyRoute())`.

---

## Testing

Test files mirror the source structure under `test/`. Use `mocktail` for mocking:

```
test/
└── features/
    ├── characters/
    │   ├── data/
    │   │   ├── models/character_model_test.dart
    │   │   └── repositories/characters_repository_impl_test.dart
    │   └── domain/
    │       └── usecases/get_characters_usecase_test.dart
    └── episodes/
        ├── data/
        │   └── repositories/episodes_repository_impl_test.dart
        └── domain/
            └── usecases/get_seasons_usecase_test.dart
```

Tests cover the **domain** and **data** layers. Presentation layer (pages/stores) is currently untested.

**Mocking pattern with mocktail:**

```dart
class MockMyRepository extends Mock implements MyRepository {}

void main() {
  late MyUseCase useCase;
  late MockMyRepository mockRepo;

  setUp(() {
    mockRepo = MockMyRepository();
    useCase = MyUseCase(mockRepo);
  });

  test('should return data on success', () async {
    when(() => mockRepo.getData(any())).thenAnswer((_) async => Right(fakeData));
    final result = await useCase(Params(...));
    expect(result, Right(fakeData));
  });
}
```

---

## Known Issues and TODOs

1. **Character detail navigation not implemented** (`character_list_item.dart:16` has a `TODO` comment) — tapping a character does nothing.
2. **OMDB API key committed** — `.env` files contain a plain-text API key. Rotate before production use.
3. **Series name hardcoded** — `episode_detail_repository_impl.dart` hardcodes `'Futurama'` as the OMDB query series name.
4. **No CI/CD pipeline** — No `.github/workflows/` directory; builds and tests are run manually.
5. **Limited test coverage** — No tests for presentation layer (pages, stores, widgets).
6. **No local data persistence** — All state is in-memory and resets on app restart.
7. **Auth interceptor stubbed** — A placeholder auth interceptor exists but is not wired up.

---

## UI Theme

Futurama-themed dark design:

| Token | Value |
|---|---|
| Primary | Orange `#FF6B35` |
| Secondary | Cyan `#00D9FF` |
| Tertiary | Purple `#7B2CBF` |
| Background | Deep space blue `#0F0F1E` |
| Custom Fonts | `Futurama`, `FuturamaTitle` (in `assets/fonts/`) |

Theme is defined in `lib/core/theme/`. Use `AppColors` constants when referencing colors.
