import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/episodes/presentation/store/episodes_store.dart';
import 'package:template_app/features/episodes/presentation/widgets/episode_list_item.dart';
import 'package:template_app/features/episodes/presentation/widgets/season_shimmer.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage>
    with AutomaticKeepAliveClientMixin {
  late final EpisodesStore _store;
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _store = getIt<EpisodesStore>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Only load if data is not already loaded
    if (_store.seasons.isEmpty && !_store.isLoading) {
      _store.loadSeasons();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _store.loadMoreSeasons();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (_store.isLoading) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const SeasonShimmer(),
            );
          }

          if (_store.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _store.failure?.message ?? 'Error loading episodes',
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _store.loadSeasons(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_store.isEmpty) {
            return const Center(child: Text('No episodes found'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: _store.seasons.length + (_store.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _store.seasons.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final season = _store.seasons[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      'Season ${season.id}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  ...season.episodes.map(
                    (episode) =>
                        EpisodeListItem(episode: episode, season: season.id),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
