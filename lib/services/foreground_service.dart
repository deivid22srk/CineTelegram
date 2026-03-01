import 'dart:isolate';
import 'package:cine_telegram/services/streaming_server.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  final _server = StreamingServer();

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    print('Foreground task started');
    // Note: The task handler in foreground task might need data passing
    // for botToken, apiId, apiHash if started from background.
    // For now, we assume it's triggered with valid state or uses a mock/default.
    // await _server.start(token, id, hash);
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Keep alive logic if needed
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print('Foreground task destroyed');
    await _server.stop();
  }
}

class ForegroundService {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Service Notification',
        channelDescription: 'CineTelegram Streaming Server',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<bool> start({
    String? botToken,
    String? apiId,
    String? apiHash,
  }) async {
    if (await FlutterForegroundTask.isRunningService) {
      return true;
    }

    return await FlutterForegroundTask.startService(
      notificationTitle: 'CineTelegram Server',
      notificationText: 'Streaming server is running...',
      callback: startCallback,
    );
  }

  static Future<bool> stop() async {
    return await FlutterForegroundTask.stopService();
  }
}
