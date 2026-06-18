import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class CountdownSection extends StatefulWidget {
  final DateTime? completedAt;

  const CountdownSection({
    Key? key,
    this.completedAt,
  }) : super(key: key);

  @override
  State<CountdownSection> createState() => _CountdownSectionState();
}

class _CountdownSectionState extends State<CountdownSection> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void didUpdateWidget(CountdownSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completedAt != widget.completedAt) {
      _calculateRemainingTime();
    }
  }

  void _calculateRemainingTime() {
    if (widget.completedAt == null) {
      _remainingTime = Duration.zero;
      return;
    }

    final now = DateTime.now();
    final expirationDate = widget.completedAt!.add(const Duration(hours: 48));
    _remainingTime = expirationDate.difference(now);

    if (_remainingTime.isNegative) {
      _remainingTime = Duration.zero;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateRemainingTime();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.completedAt == null || _remainingTime.isNegative || _remainingTime == Duration.zero) {
      return const SizedBox.shrink();
    }

    String hours = _remainingTime.inHours.toString().padLeft(2, '0');
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        const Text(
          "• L'OFFRE EXPIRE DANS •",
          style: TextStyle(
            color: MichelinTheme.blueMichelin,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeBox(hours, "HEURES"),
            const Text(" : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
            _buildTimeBox(minutes, "MIN"),
            const Text(" : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
            _buildTimeBox(seconds, "SEC"),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Text(
            "Ce lien est unique. Il expire dans 48h ou dès épuisement du stock.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox(String value, String unit) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MichelinTheme.blueMichelin,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
