/// Model sederhana untuk satu alarm.
class AlarmModel {
  final int id;
  int hour;
  int minute;
  bool enabled;
  String label;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    this.enabled = true,
    this.label = 'Alarm',
  });

  /// Format waktu dua digit, contoh: 07:05
  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'enabled': enabled,
        'label': label,
      };

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
        id: json['id'] as int,
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        enabled: json['enabled'] as bool? ?? true,
        label: json['label'] as String? ?? 'Alarm',
      );
}
