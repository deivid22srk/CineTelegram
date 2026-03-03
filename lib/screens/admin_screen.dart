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
  final _categoryController = TextEditingController();

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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<MediaProvider>(context, listen: false).updateSettings(
                        token: _botTokenController.text,
                        groupId: _groupIdController.text,
                        apiId: _apiIdController.text,
                        apiHash: _apiHashController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configurações salvas!')));
                    },
                    child: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<MediaProvider>(context, listen: false).backup();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup concluído no Telegram!')));
                    },
                    child: const Text('Backup'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<MediaProvider>(context, listen: false).restore();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restauração concluída!')));
                    },
                    child: const Text('Restaurar'),
                  ),
                ),
              ],
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
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Categoria')),
            TextField(controller: _posterUrlController, decoration: const InputDecoration(labelText: 'URL do Poster')),
            TextField(controller: _backdropUrlController, decoration: const InputDecoration(labelText: 'URL do Backdrop')),
            TextField(controller: _ratingController, decoration: const InputDecoration(labelText: 'Avaliação')),
            TextField(controller: _yearController, decoration: const InputDecoration(labelText: 'Ano')),
            TextField(controller: _genresController, decoration: const InputDecoration(labelText: 'Gêneros (vírgula)')),
            TextField(
              controller: _fileIdController,
              decoration: InputDecoration(
                labelText: 'Telegram File ID / Message Link',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.auto_fix_high),
                  onPressed: _captureFromTelegram,
                  tooltip: 'Capturar do Telegram',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMedia,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              child: Text(_mediaType == MediaType.movie ? 'Adicionar Filme' : 'Adicionar Série'),
            ),
          ],
        ),
      ),
    );
  }

  void _captureFromTelegram() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aguardando vídeo ser enviado para o grupo...')));
    // Real logic would listen for updates or prompt user to forward.
  }

  void _saveMedia() {
    final provider = Provider.of<MediaProvider>(context, listen: false);
    final id = const Uuid().v4();
    final genres = _genresController.text.split(',').map((e) => e.trim()).toList();
    final rating = double.tryParse(_ratingController.text) ?? 0.0;
    final year = int.tryParse(_yearController.text) ?? 2024;
    final category = _categoryController.text.isEmpty ? 'Geral' : _categoryController.text;

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
        category: category,
      );
    } else {
      newMedia = Series(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        posterUrl: _posterUrlController.text,
        backdropUrl: _backdropUrlController.text,
        rating: rating,
        year: year,
        genres: genres,
        category: category,
        seasons: [
          Season(
            id: const Uuid().v4(),
            title: 'Temporada 1',
            number: 1,
            episodes: [
              Episode(
                id: const Uuid().v4(),
                title: 'Episódio 1',
                number: 1,
                description: 'Piloto',
                thumbnail: _posterUrlController.text,
                telegramFileId: _fileIdController.text,
              ),
            ],
          ),
        ],
      );
    }

    provider.addMedia(newMedia);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mídia adicionada!')));
    _clearFields();
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _posterUrlController.clear();
    _backdropUrlController.clear();
    _ratingController.clear();
    _yearController.clear();
    _genresController.clear();
    _fileIdController.clear();
  }
}
