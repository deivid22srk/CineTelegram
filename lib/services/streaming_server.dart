import 'dart:async';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:cine_telegram/services/telegram_mtproto_service.dart';

class StreamingServer {
  static final StreamingServer _instance = StreamingServer._internal();
  factory StreamingServer() => _instance;
  StreamingServer._internal();

  HttpServer? _server;
  final String host = '127.0.0.1';
  final int port = 8080;
  TelegramMtprotoService? _mtprotoService;

  Future<void> start(String botToken, String apiId, String apiHash) async {
    if (_server != null) return;

    _mtprotoService = TelegramMtprotoService(
      botToken: botToken,
      apiId: apiId,
      apiHash: apiHash,
    );
    await _mtprotoService!.initialize();

    final router = Router();
    router.get('/stream/<fileId>', _handleStream);

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router);

    _server = await io.serve(handler, host, port);
    print('Streaming server running on http://$host:$port');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<Response> _handleStream(Request request, String fileId) async {
    final rangeHeader = request.headers['range'];
    print('Streaming request for $fileId, Range: $rangeHeader');

    if (_mtprotoService == null) {
      return Response.internalServerError(body: 'MTProto service not initialized.');
    }

    final totalSize = await _mtprotoService!.getFileSize(fileId);

    if (rangeHeader != null && rangeHeader.startsWith('bytes=')) {
      final range = rangeHeader.substring(6).split('-');
      final start = int.parse(range[0]);
      final end = range.length > 1 && range[1].isNotEmpty
          ? int.parse(range[1])
          : totalSize - 1;

      final contentLength = end - start + 1;

      // Actual byte streaming from Telegram via MTProto chunk-fetching logic
      final stream = _mtprotoService!.streamFilePart(fileId, start, contentLength);

      return Response(
        206, // Partial Content
        body: stream,
        headers: {
          'Content-Type': 'video/mp4',
          'Accept-Ranges': 'bytes',
          'Content-Range': 'bytes $start-$end/$totalSize',
          'Content-Length': '$contentLength',
        },
      );
    }

    // Default: return small chunk for full file request if no range (though players usually range)
    return Response.ok(
      _mtprotoService!.streamFilePart(fileId, 0, 1024),
      headers: {
        'Content-Type': 'video/mp4',
        'Accept-Ranges': 'bytes',
        'Content-Length': '1024',
      },
    );
  }

  String getStreamUrl(String fileId) {
    return 'http://$host:$port/stream/$fileId';
  }
}
