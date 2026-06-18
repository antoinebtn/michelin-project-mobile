import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class FooterBrand extends StatelessWidget {
  final VoidCallback onShare;

  const FooterBrand({
    Key? key,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MichelinTheme.blueMichelin, width: double.infinity, padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.directions_bike, color: MichelinTheme.yellowMichelin, size: 40),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share, color: Colors.white),
            label: const Text("PARTAGER LE DÉFI", style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          const Text(
            "Offre valable uniquement sur ce lien personnel et non transférable.\nStock limité — 500 packs disponibles pour ce drop.",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
