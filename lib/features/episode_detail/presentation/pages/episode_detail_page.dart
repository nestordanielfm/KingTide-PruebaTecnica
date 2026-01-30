import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/episode_detail/presentation/store/episode_detail_store.dart';
import 'package:template_app/features/episode_detail/presentation/widgets/episode_detail_content.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class EpisodeDetailPage extends StatefulWidget {
  final int season;
  final int episode;
  final String? episodeName;

  const EpisodeDetailPage({
    super.key,
    @PathParam('season') required this.season,
    @PathParam('episode') required this.episode,
    @QueryParam('name') this.episodeName,
  });

  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  late final EpisodeDetailStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<EpisodeDetailStore>();
    _store.loadEpisodeDetail(widget.season, widget.episode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          if (_store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.errorMessage != null) {
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
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _store.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _store.loadEpisodeDetail(widget.season, widget.episode);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_store.episodeDetail == null) {
            return const Center(child: Text('No data available'));
          }

          return EpisodeDetailContent(episodeDetail: _store.episodeDetail!);
        },
      ),
    );
  }
}
