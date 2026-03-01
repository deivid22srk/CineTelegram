import 'package:cine_telegram/models/episode.dart';
import 'package:cine_telegram/models/media.dart';
import 'package:cine_telegram/models/movie.dart';
import 'package:cine_telegram/models/season.dart';
import 'package:cine_telegram/models/series.dart';
import 'package:cine_telegram/providers/media_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _botTokenController = TextEditingController();
  final _groupIdController = TextEditingController();
  final _apiIdController = TextEditingController();
  final _apiHashController = TextEditingController();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _backdropUrlController = TextEditingController();
  final _ratingController = TextEditingController();
  final _yearController = TextEditingController();
  final _genresController = TextEditingController();
  final _fileIdController = TextEditingController();

  MediaType _mediaType = MediaType.movie;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MediaProvider>(context, listen: false);
    _botTokenController.text = provider.botToken ?? '';
    _groupIdController.text = provider.groupId ?? '';
    _apiIdController.text = provider.apiId ?? '';
    _apiHashController.text = provider.apiHash ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administração')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Configurações do Telegram', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: _botTokenController, decoration: const InputDecoration(labelText: 'Bot Token')),
            TextField(controller: _groupIdController, decoration: const InputDecoration(labelText: 'Group ID')),
            TextField(controller: _apiIdController, decoration: const InputDecoration(labelText: 'API ID')),
            TextField(controller: _apiHashController, decoration: const InputDecoration(labelText: 'API HASH')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Provider.of<MediaProvider>(context, listen: false).updateSettings(
                  token: _botTokenController.text,
                  groupId: _groupIdController.text,
                  apiId: _apiIdController.text,
                  apiHash: _apiHashController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configurações salvas!')));
              },
              child: const Text('Salvar Configurações'),
            ),
            const Divider(height: 40),
            const Text('Adicionar Novo Conteúdo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Tipo: '),
                Radio<MediaType>(
                  value: MediaType.movie,
                  groupValue: _mediaType,
                  onChanged: (v) => setState(() => _mediaType = v!),
                ),
                const Text('Filme'),
                Radio<MediaType>(
                  value: MediaType.series,
                  groupValue: _mediaType,
                  onChanged: (v) => setState(() => _mediaType = v!),
                ),
                const Text('Série'),
              ],
            ),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descrição')),
            TextField(controller: _posterUrlController, decoration: const InputDecoration(labelText: 'URL do Poster')),
            TextField(controller: _backdropUrlController, decoration: const InputDecoration(labelText: 'URL do Backdrop')),
            TextField(controller: _ratingController, decoration: const InputDecoration(labelText: 'Avaliação (ex: 8.5)')),
            TextField(controller: _yearController, decoration: const InputDecoration(labelText: 'Ano')),
            TextField(controller: _genresController, decoration: const InputDecoration(labelText: 'Gêneros (separados por vírgula)')),
            if (_mediaType == MediaType.movie)
              TextField(controller: _fileIdController, decoration: const InputDecoration(labelText: 'Telegram File ID')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMedia,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: Text(_mediaType == MediaType.movie ? 'Adicionar Filme' : 'Adicionar Série (Vazia)'),
            ),
            const SizedBox(height: 40),
            if (_mediaType == MediaType.series) ...[
              const Text('Nota: Após criar a série, você pode implementar a lógica para adicionar temporadas e episódios clicando nela (Mocked for this sample).',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  void _saveMedia() {
    final provider = Provider.of<MediaProvider>(context, listen: false);
    final id = const Uuid().v4();
    final genres = _genresController.text.split(',').map((e) => e.trim()).toList();
    final rating = double.tryParse(_ratingController.text) ?? 0.0;
    final year = int.tryParse(_yearController.text) ?? 2024;

    Media newMedia;

    if (_mediaType == MediaType.movie) {
      newMedia = Movie(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        posterUrl: _posterUrlController.text,
        backdropUrl: _backdropUrlController.text,
        rating: rating,
        year: year,
        genres: genres,
        telegramFileId: _fileIdController.text,
      );
    } else {
      // For demo purposes, we'll create a series with a dummy season and episode
      // A more complex implementation would involve another screen to manage seasons.
      newMedia = Series(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        posterUrl: _posterUrlController.text,
        backdropUrl: _backdropUrlController.text,
        rating: rating,
        year: year,
        genres: genres,
        seasons: [
          Season(
            id: const Uuid().v4(),
            title: 'Temporada 1',
            number: 1,
            episodes: [
              Episode(
                id: const Uuid().v4(),
                title: 'Episódio Piloto',
                number: 1,
                description: 'Início da jornada.',
                thumbnail: _posterUrlController.text,
                telegramFileId: _fileIdController.text,
              ),
            ],
          ),
        ],
      );
    }

    provider.addMedia(newMedia);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mídia adicionada com sucesso!')));
    _clearFields();
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _posterUrlController.clear();
    _backdropUrlController.clear();
    _ratingController.clear();
    _yearController.clear();
    _genresController.clear();
    _fileIdController.clear();
  }
}
