import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'models/alarm_model.dart';
import 'services/alarm_service.dart';
import 'services/coin_service.dart';
import 'screens/home_screen.dart';
import 'screens/ringing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final coinService = CoinService();
  final alarmService = AlarmService();
  await coinService.load();
  await alarmService.load();

  runApp(CoinAlarmApp(
    coinService: coinService,
    alarmService: alarmService,
  ));
}

class CoinAlarmApp extends StatefulWidget {
  final CoinService coinService;
  final AlarmService alarmService;

  const CoinAlarmApp({
    super.key,
    required this.coinService,
    required this.alarmService,
  });

  @override
  State<CoinAlarmApp> createState() => _CoinAlarmAppState();
}

class _CoinAlarmAppState extends State<CoinAlarmApp> {
  final _navKey = GlobalKey<NavigatorState>();
  final _player = AudioPlayer();

  Timer? _ticker;
  bool _ringing = false;
  int? _lastFiredMinute; // cegah alarm yang sama nembak berkali-kali dalam 1 menit

  @override
  void initState() {
    super.initState();
    // Cek tiap detik apakah ada alarm yang jatuh tempo.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _checkAlarms());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _checkAlarms() async {
    if (_ringing) return;
    final now = DateTime.now();
    final minuteKey = now.hour * 60 + now.minute;
    if (_lastFiredMinute == minuteKey) return;

    final due = widget.alarmService.findDueAlarm(now);
    if (due != null && now.second == 0) {
      _lastFiredMinute = minuteKey;
      await _triggerAlarm(due);
    }
  }

  /// Mulai bunyi + buka layar RingingScreen.
  Future<void> _triggerAlarm(AlarmModel alarm) async {
    if (_ringing) return;
    _ringing = true;
    await _startSound();

    final navigator = _navKey.currentState;
    if (navigator == null) {
      _ringing = false;
      return;
    }

    await navigator.push(
      MaterialPageRoute(
        builder: (_) => RingingScreen(
          alarm: alarm,
          coinService: widget.coinService,
          onStopSound: _stopSound,
        ),
      ),
    );
    _ringing = false;
  }

  Future<void> _startSound() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      // Nada alarm dari asset. Kalau asset belum ada, dibungkus try/catch
      // supaya app tetap jalan (silent alarm).
      await _player.play(AssetSource('sounds/alarm.mp3'));
    } catch (_) {
      // Aman diabaikan kalau file suara belum ditambahkan.
    }
  }

  Future<void> _stopSound() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Alarm',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navKey,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: HomeScreen(
        alarmService: widget.alarmService,
        coinService: widget.coinService,
        onTriggerAlarm: _triggerAlarm,
      ),
    );
  }
}
