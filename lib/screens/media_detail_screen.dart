import 'package:cine_telegram/models/episode.dart';
import 'package:cine_telegram/models/media.dart';
import 'package:cine_telegram/models/movie.dart';
import 'package:cine_telegram/models/series.dart';
import 'package:cine_telegram/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaDetailScreen extends StatelessWidget {
  final Media media;

  const MediaDetailScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${media.year}  •  ',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('HD', style: TextStyle(fontSize: 10)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${media.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (media is Movie)
                    _buildPlayButton(context, (media as Movie).telegramFileId, media.title, media.id),
                  const SizedBox(height: 16),
                  Text(
                    media.description,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  if (media is Series) _buildSeasonList(context, media as Series),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(media.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: media.backdropUrl,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, String telegramFileId, String title, String progressId) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: () => _navigateToPlayer(context, telegramFileId, title, progressId),
      icon: const Icon(Icons.play_arrow),
      label: const Text('Assistir Agora'),
    );
  }

  Widget _buildSeasonList(BuildContext context, Series series) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Temporadas e Episódios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: series.seasons.length,
          itemBuilder: (context, sIndex) {
            final season = series.seasons[sIndex];
            return ExpansionTile(
              title: Text('Temporada ${season.number}: ${season.title}'),
              children: season.episodes.map((episode) => _buildEpisodeItem(context, episode)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEpisodeItem(BuildContext context, Episode episode) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: episode.thumbnail,
          width: 80,
          height: 45,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(color: Colors.grey[800], child: const Icon(Icons.movie)),
        ),
      ),
      title: Text('${episode.number}. ${episode.title}', style: const TextStyle(fontSize: 14)),
      subtitle: Text(episode.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
      onTap: () => _navigateToPlayer(context, episode.telegramFileId, episode.title, episode.id),
    );
  }

  void _navigateToPlayer(BuildContext context, String telegramFileId, String title, String progressId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(
          telegramFileId: telegramFileId,
          title: title,
          progressId: progressId,
        ),
      ),
    );
  }
}
