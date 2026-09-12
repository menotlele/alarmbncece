import 'dart:async';
import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/coin_service.dart';
import 'challenge_dialog.dart';

/// Layar yang muncul saat alarm berbunyi.
///
/// User HARUS "membayar" koin virtual untuk mematikan alarm. Kalau koin habis,
/// mereka bisa menyelesaikan tantangan untuk dapat koin gratis. Tidak ada
/// uang sungguhan yang terlibat — murni iseng & gamifikasi.
class RingingScreen extends StatefulWidget {
  final AlarmModel alarm;
  final CoinService coinService;
  final Future<void> Function() onStopSound;

  const RingingScreen({
    super.key,
    required this.alarm,
    required this.coinService,
    required this.onStopSound,
  });

  @override
  State<RingingScreen> createState() => _RingingScreenState();
}

class _RingingScreenState extends State<RingingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late Timer _clock;
  String _now = '';

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _updateClock();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }

  void _updateClock() {
    final now = DateTime.now();
    setState(() {
      _now =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _clock.cancel();
    super.dispose();
  }

  Future<void> _payAndStop() async {
    final ok = await widget.coinService.payToStop();
    if (!mounted) return;
    if (ok) {
      await _finish();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Koin kurang! Selesaikan tantangan dulu 😈'),
        ),
      );
    }
  }

  Future<void> _earnCoins() async {
    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ChallengeDialog(),
    );
    if (success == true) {
      await widget.coinService.addCoins(CoinService.challengeReward);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dapat ${CoinService.challengeReward} koin! 🪙'),
        ),
      );
    }
  }

  Future<void> _finish() async {
    await widget.onStopSound();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Cegah user kabur pakai tombol back tanpa "bayar". Chaos! 😈
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.red.shade700,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.1).animate(_pulse),
                  child: const Icon(Icons.alarm,
                      size: 120, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  '⏰ ${widget.alarm.label}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _now,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 40),
                ListenableBuilder(
                  listenable: widget.coinService,
                  builder: (context, _) {
                    final coin = widget.coinService;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '🪙 Saldo: ${coin.balance} koin',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          onPressed: coin.canAfford ? _payAndStop : null,
                          icon: const Icon(Icons.money_off),
                          label: Text(
                            'Bayar ${CoinService.costToStop} koin & matikan',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _earnCoins,
                          icon: const Icon(Icons.psychology),
                          label: const Text(
                            'Koin habis? Selesaikan tantangan',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
