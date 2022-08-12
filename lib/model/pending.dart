class Pending {
  final String machine;
  final String shift;
  final String date;
  final int pending;
  final int stockIn;

  Pending({
    required this.machine,
    required this.shift,
    required this.date,
    required this.pending,
    required this.stockIn,
  });

  factory Pending.fromJson(Map<String, dynamic> json) {
    return Pending(
      machine: json['machine'] as String,
      shift: json['shift'] as String,
      date: json['date'] as String,
      pending: json['pending'] as int,
      stockIn: json['stockIn'] as int,
    );
  }
}
