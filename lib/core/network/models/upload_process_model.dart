// ================================
// Upload Progress Model
// ================================

class UploadProgress {
  final int sent;
  final int total;
  final double percentage;
  final String humanReadableSpeed;
  final Duration estimatedTimeRemaining;

  UploadProgress({
    required this.sent,
    required this.total,
    required this.percentage,
    required this.humanReadableSpeed,
    required this.estimatedTimeRemaining,
  });

  factory UploadProgress.fromBytes(int sent, int total, [DateTime? startTime]) {
    final percentage = total > 0 ? (sent / total) * 100 : 0.0;

    String speed = '0 B/s';
    Duration eta = Duration.zero;

    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed.inSeconds > 0) {
        final bytesPerSecond = sent / elapsed.inSeconds;
        speed = '${_formatBytes(bytesPerSecond.round())}/s';

        if (bytesPerSecond > 0 && sent < total) {
          final remaining = total - sent;
          eta = Duration(seconds: (remaining / bytesPerSecond).round());
        }
      }
    }

    return UploadProgress(
      sent: sent,
      total: total,
      percentage: percentage,
      humanReadableSpeed: speed,
      estimatedTimeRemaining: eta,
    );
  }

  static String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
