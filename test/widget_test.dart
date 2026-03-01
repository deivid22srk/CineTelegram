import 'package:flutter_test/flutter_test.dart';
import 'package:cine_telegram/main.dart';
import 'package:cine_telegram/providers/media_provider.dart';
import 'package:cine_telegram/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MediaProvider(storageService)),
        ],
        child: const CineTelegramApp(),
      ),
    );

    expect(find.text('CineTelegram'), findsOneWidget);
  });
}
