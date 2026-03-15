import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String label;
  final String status;
  final bool isAlert;

  const StatusIndicator({
    super.key,
    required this.label,
    required this.status,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isAlert ? Colors.redAccent : Colors.greenAccent;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: statusColor.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAlert ? Icons.warning_rounded : Icons.check_circle_rounded,
                color: statusColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
