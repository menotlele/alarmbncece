import 'dart:math';
import 'package:flutter/material.dart';

/// Dialog tantangan matematika. Kalau user jawab benar, dapat koin gratis.
/// Return true kalau berhasil.
class ChallengeDialog extends StatefulWidget {
  const ChallengeDialog({super.key});

  @override
  State<ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<ChallengeDialog> {
  late int _a;
  late int _b;
  final _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    final rng = Random();
    _a = rng.nextInt(40) + 10; // 10..49
    _b = rng.nextInt(40) + 10;
    _error = null;
    _controller.clear();
  }

  void _check() {
    final answer = int.tryParse(_controller.text.trim());
    if (answer == null) {
      setState(() => _error = 'Masukkan angka dong 😅');
      return;
    }
    if (answer == _a + _b) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = 'Salah! Coba lagi 😈';
        _generate();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🧠 Tantangan Koin Gratis'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Jawab benar buat dapat koin gratis!'),
          const SizedBox(height: 16),
          Text(
            '$_a + $_b = ?',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Jawabanmu',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _check(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _check,
          child: const Text('Cek Jawaban'),
        ),
      ],
    );
  }
}
