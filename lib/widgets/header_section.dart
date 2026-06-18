import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1541614101331-1a5a3a194e92'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(height: 300, color: MichelinTheme.blueMichelin.withOpacity(0.4)),
        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("UNLOCK &", style: MichelinTheme.headerStyle),
              Text("RIDE.", style: MichelinTheme.yellowHeaderStyle),
            ],
          ),
        )
      ],
    );
  }
}
