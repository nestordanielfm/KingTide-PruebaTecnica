import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/episodes/domain/entities/episode.dart';

class EpisodeListItem extends StatelessWidget {
  final Episode episode;
  final int season;

  const EpisodeListItem({
    super.key,
    required this.episode,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.router.push(
          EpisodeDetailRoute(
            season: season,
            episode: episode.number,
            episodeName: episode.name,
          ),
        );
      },
      child: ListTile(
        leading: Hero(
          tag: 'episode-$season-${episode.number}',
          child: CircleAvatar(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textOnSecondary,
            child: Text(
              '${episode.number}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          episode.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Production Code: ${episode.productionCode}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
