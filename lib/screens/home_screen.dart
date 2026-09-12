import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';
import '../services/coin_service.dart';

class HomeScreen extends StatelessWidget {
  final AlarmService alarmService;
  final CoinService coinService;

  /// Dipanggil untuk memicu layar alarm berbunyi (dipakai tombol test).
  final void Function(AlarmModel alarm) onTriggerAlarm;

  const HomeScreen({
    super.key,
    required this.alarmService,
    required this.coinService,
    required this.onTriggerAlarm,
  });

  Future<void> _addAlarm(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      await alarmService.addAlarm(picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Coin Alarm'),
        actions: [
          // Saldo koin di pojok kanan atas.
          ListenableBuilder(
            listenable: coinService,
            builder: (context, _) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '🪙 ${coinService.balance}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _InfoBanner(coinService: coinService),
          Expanded(
            child: ListenableBuilder(
              listenable: alarmService,
              builder: (context, _) {
                final alarms = alarmService.alarms;
                if (alarms.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada alarm.\nTekan + untuk menambah 😴',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.alarm, size: 36),
                        title: Text(
                          alarm.timeLabel,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(alarm.label),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Test bunyikan sekarang',
                              icon: const Icon(Icons.play_circle_fill),
                              onPressed: () => onTriggerAlarm(alarm),
                            ),
                            Switch(
                              value: alarm.enabled,
                              onChanged: (_) =>
                                  alarmService.toggleAlarm(alarm.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  alarmService.removeAlarm(alarm.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAlarm(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Alarm'),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final CoinService coinService;
  const _InfoBanner({required this.coinService});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.amber.shade100,
      padding: const EdgeInsets.all(12),
      child: Text(
        'Tiap matiin alarm butuh ${CoinService.costToStop} koin 🪙. '
        'Koin habis? Selesaikan tantangan pas alarm bunyi buat dapat gratis!',
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
