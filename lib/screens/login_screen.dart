import 'package:cine_telegram/providers/media_provider.dart';
import 'package:cine_telegram/services/telegram_mtproto_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _phoneCodeHash;
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login com Telegram')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            if (!_codeSent) ...[
              const Text('Insira seu número de telefone (com DDD)'),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendCode,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: _isLoading ? const CircularProgressIndicator() : const Text('Enviar Código'),
              ),
            ] else ...[
              const Text('Insira o código enviado pelo Telegram'),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Código de Confirmação',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: _isLoading ? const CircularProgressIndicator() : const Text('Entrar'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _sendCode() async {
    final provider = Provider.of<MediaProvider>(context, listen: false);
    if (provider.apiId == null || provider.apiHash == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configure API ID e API Hash primeiro!')));
      return;
    }

    setState(() => _isLoading = true);
    final service = TelegramMtprotoService(
      botToken: provider.botToken ?? '',
      apiId: provider.apiId!,
      apiHash: provider.apiHash!,
    );

    try {
      _phoneCodeHash = await service.sendCode(_phoneController.text);
      setState(() {
        _codeSent = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  void _signIn() async {
    final provider = Provider.of<MediaProvider>(context, listen: false);
    setState(() => _isLoading = true);

    final service = TelegramMtprotoService(
      botToken: provider.botToken ?? '',
      apiId: provider.apiId!,
      apiHash: provider.apiHash!,
    );

    try {
      final success = await service.signIn(_phoneController.text, _phoneCodeHash!, _codeController.text);
      if (success) {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }
}
