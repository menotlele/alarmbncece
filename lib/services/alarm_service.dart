import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm_model.dart';

/// Mengelola daftar alarm dan menyimpannya secara lokal.
class AlarmService extends ChangeNotifier {
  static const String _key = 'alarms';

  final List<AlarmModel> _alarms = [];
  List<AlarmModel> get alarms => List.unmodifiable(_alarms);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    _alarms.clear();
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      for (final item in decoded) {
        _alarms.add(AlarmModel.fromJson(item as Map<String, dynamic>));
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_alarms.map((a) => a.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> addAlarm(int hour, int minute, {String label = 'Alarm'}) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    _alarms.add(AlarmModel(id: id, hour: hour, minute: minute, label: label));
    _alarms.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
    notifyListeners();
    await _save();
  }

  Future<void> toggleAlarm(int id) async {
    final alarm = _alarms.firstWhere((a) => a.id == id);
    alarm.enabled = !alarm.enabled;
    notifyListeners();
    await _save();
  }

  Future<void> removeAlarm(int id) async {
    _alarms.removeWhere((a) => a.id == id);
    notifyListeners();
    await _save();
  }

  /// Cari alarm aktif yang cocok dengan jam & menit saat ini.
  AlarmModel? findDueAlarm(DateTime now) {
    for (final alarm in _alarms) {
      if (alarm.enabled && alarm.hour == now.hour && alarm.minute == now.minute) {
        return alarm;
      }
    }
    return null;
  }
}
