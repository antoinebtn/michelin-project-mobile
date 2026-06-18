import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class ReviewCard extends StatelessWidget {
  final String author;
  final String initial;
  final String text;

  const ReviewCard({
    Key? key,
    required this.author,
    required this.initial,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: const BorderSide(color: MichelinTheme.borderGrey, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 14,
                    backgroundColor: MichelinTheme.blueMichelin,
                    child: Text(initial.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                ),
                const SizedBox(width: 10),
                Text(author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
                const Spacer(),
                Row(children: List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14))),
              ],
            ),
            const SizedBox(height: 12),
            Text('"$text"', style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
          ],
        ),
      ),
    );
  }
}
