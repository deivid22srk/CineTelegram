import 'package:cine_telegram/providers/media_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {
  final String telegramFileId;
  final String title;
  final String progressId;

  const PlayerScreen({
    super.key,
    required this.telegramFileId,
    required this.title,
    required this.progressId,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final url = await mediaProvider.getMediaStreamUrl(widget.telegramFileId);

    if (url == null) {
      setState(() {
        _isLoading = false;
        _error = 'Erro ao carregar link do vídeo. Verifique as configurações do bot.';
      });
      return;
    }

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _videoPlayerController!.initialize();
      final initialProgress = await mediaProvider.getProgress(widget.progressId);

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        startAt: Duration(seconds: initialProgress),
        placeholder: Container(color: Colors.black),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
      );

      _videoPlayerController!.addListener(_saveProgress);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Erro ao inicializar player: $e';
      });
    }
  }

  void _saveProgress() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      final currentPosition = _videoPlayerController!.value.position.inSeconds;
      Provider.of<MediaProvider>(context, listen: false).saveProgress(widget.progressId, currentPosition);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_saveProgress);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.red)
            : _error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _initializePlayer();
                        },
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  )
                : AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
      ),
    );
  }
}
