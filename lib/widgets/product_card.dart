import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> pack;

  const ProductCard({
    Key? key,
    required this.pack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  pack['imageUrl'] ?? 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.unsplash.com/photo-1517649763962-0c623066013b',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    color: MichelinTheme.yellowMichelin,
                    child: const Text("EXCLUSIF DROP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pack['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text(pack['subtitle'] ?? '', style: const TextStyle(color: MichelinTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text("${pack['price']} €", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
                          const SizedBox(width: 8),
                          Text("${pack['originalPrice']} €", style: TextStyle(fontSize: 14, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: MichelinTheme.yellowMichelin, borderRadius: BorderRadius.circular(2)),
                        child: Text("-${pack['discountPercentage']}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
