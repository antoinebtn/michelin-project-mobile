import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class TechnologySection extends StatelessWidget {
  final List<dynamic> technologies;

  const TechnologySection({
    Key? key,
    required this.technologies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Align(alignment: Alignment.centerLeft, child: Text("TECHNOLOGIE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(color: MichelinTheme.bgLight, border: Border.all(color: MichelinTheme.borderGrey), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: technologies.map<Widget>((tech) {
                IconData techIcon = Icons.star_border;
                if (tech['icon'] == 'bolt') techIcon = Icons.bolt;
                if (tech['icon'] == 'shield') techIcon = Icons.shield_outlined;
                if (tech['icon'] == 'straighten') techIcon = Icons.straighten;

                return Column(
                  children: [
                    _buildSpecRow(techIcon, tech['label'] ?? '', tech['value'] ?? ''),
                    if (tech != technologies.last)
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider(height: 1, color: MichelinTheme.borderGrey)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: MichelinTheme.blueMichelin),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
        ],
      ),
    );
  }
}
