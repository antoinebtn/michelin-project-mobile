import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class StockBar extends StatelessWidget {
  final int remainingPercentage;

  const StockBar({
    Key? key,
    required this.remainingPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("STOCK DROP", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
              Text("$remainingPercentage% restant", style: const TextStyle(fontSize: 11, color: MichelinTheme.blueMichelin, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
                value: (remainingPercentage / 100).toDouble(),
                backgroundColor: MichelinTheme.borderGrey, color: MichelinTheme.yellowMichelin, minHeight: 8
            ),
          ),
        ),
      ],
    );
  }
}
