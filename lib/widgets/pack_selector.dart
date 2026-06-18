import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class PackSelector extends StatelessWidget {
  final List<dynamic> packs;
  final Map<String, dynamic>? selectedPack;
  final Function(Map<String, dynamic>) onPackSelected;

  const PackSelector({
    Key? key,
    required this.packs,
    required this.selectedPack,
    required this.onPackSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (packs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Aucun pack disponible dans cette catégorie.", style: TextStyle(color: Colors.grey, fontSize: 13)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CHOISISSEZ VOTRE PACK :", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: MichelinTheme.textMuted)),
          const SizedBox(height: 8),
          Row(
            children: packs.map((pack) {
              bool isCurrent = selectedPack?['id'] == pack['id'];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: OutlinedButton(
                    onPressed: () => onPackSelected(pack),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isCurrent ? MichelinTheme.blueMichelin.withOpacity(0.05) : Colors.white,
                      side: BorderSide(color: isCurrent ? MichelinTheme.blueMichelin : MichelinTheme.borderGrey, width: isCurrent ? 2 : 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text(
                      pack['name'] ?? '',
                      style: TextStyle(color: isCurrent ? MichelinTheme.blueMichelin : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
