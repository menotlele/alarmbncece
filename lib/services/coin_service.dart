import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mengelola saldo koin virtual (mata uang bohongan, bukan uang sungguhan).
///
/// Koin dipakai untuk "membayar" agar alarm bisa dimatikan. Kalau koin habis,
/// user harus menyelesaikan tantangan untuk dapat koin gratis lagi.
class CoinService extends ChangeNotifier {
  static const String _key = 'coin_balance';
  static const int startingBalance = 500;

  /// Biaya untuk mematikan alarm.
  static const int costToStop = 100;

  /// Hadiah koin dari menyelesaikan tantangan.
  static const int challengeReward = 100;

  int _balance = startingBalance;
  int get balance => _balance;

  bool get canAfford => _balance >= costToStop;

  /// Muat saldo dari penyimpanan lokal.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getInt(_key) ?? startingBalance;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, _balance);
  }

  /// Coba bayar untuk matikan alarm. Return true kalau berhasil.
  Future<bool> payToStop() async {
    if (!canAfford) return false;
    _balance -= costToStop;
    notifyListeners();
    await _save();
    return true;
  }

  /// Tambah koin (misalnya hadiah dari tantangan).
  Future<void> addCoins(int amount) async {
    _balance += amount;
    notifyListeners();
    await _save();
  }

  /// Reset saldo ke awal (buat testing / iseng).
  Future<void> reset() async {
    _balance = startingBalance;
    notifyListeners();
    await _save();
  }
}
