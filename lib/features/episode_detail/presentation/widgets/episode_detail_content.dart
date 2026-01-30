import 'package:flutter/material.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/episode_detail/domain/entities/episode_detail.dart';

class EpisodeDetailContent extends StatelessWidget {
  final EpisodeDetail episodeDetail;

  const EpisodeDetailContent({super.key, required this.episodeDetail});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // AppBar with poster image
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              episodeDetail.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            background: Hero(
              tag: 'episode-${episodeDetail.season}-${episodeDetail.episode}',
              child: Stack(
                fit: StackFit.expand,
                children: [
                  episodeDetail.poster != 'N/A'
                      ? Image.network(
                          episodeDetail.poster,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Episode info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'S${episodeDetail.season} E${episodeDetail.episode}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      episodeDetail.released,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      episodeDetail.runtime,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Rating and info
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.gold, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      episodeDetail.imdbRating,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('/10', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    Text(
                      '(${episodeDetail.imdbVotes} votes)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Genres
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: episodeDetail.genre.map((genre) {
                    return Chip(
                      label: Text(genre),
                      backgroundColor: AppColors.surfaceVariant,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Plot
                _buildSection(
                  context,
                  'Plot',
                  Icons.description,
                  episodeDetail.plot,
                ),

                // Director
                _buildSection(
                  context,
                  'Director',
                  Icons.movie_creation,
                  episodeDetail.director,
                ),

                // Writer
                _buildSection(
                  context,
                  'Writer',
                  Icons.edit,
                  episodeDetail.writer,
                ),

                // Actors
                _buildSection(
                  context,
                  'Actors',
                  Icons.people,
                  episodeDetail.actors.join(', '),
                ),

                // Additional info
                if (episodeDetail.ratings.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Ratings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...episodeDetail.ratings.map((rating) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        rating,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 16),
                _buildInfoRow(context, 'Language', episodeDetail.language),
                _buildInfoRow(context, 'Country', episodeDetail.country),
                _buildInfoRow(context, 'Rated', episodeDetail.rated),
                if (episodeDetail.awards != 'N/A')
                  _buildInfoRow(context, 'Awards', episodeDetail.awards),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.accent),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
