import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MichelinDropPage extends StatefulWidget {
  const MichelinDropPage({Key? key}) : super(key: key);

  @override
  State<MichelinDropPage> createState() => _MichelinDropPageState();
}

class _MichelinDropPageState extends State<MichelinDropPage> {
  // Déclaration des couleurs
  static const Color blueMichelin = Color(0xFF1C4494);
  static const Color yellowMichelin = Color(0xFFFFF000);
  static const Color textMuted = Color(0xFF5C76A6);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);

  // Variables d'état pour les avis de l'API
  List<dynamic> _reviews = [];
  double _averageRating = 4.8; // Valeur par défaut
  int _totalReviews = 0;
  bool _isLoadingReviews = true;

  @override
  void initState() {
    super.initState();
    _fetchApiReviews();
  }

  // Requête API pour récupérer les avis du produit
  void _fetchApiReviews() async {
    final data = await ApiService().getProductReviews('pack-gravel-premium');
    if (data != null && mounted) {
      setState(() {
        _reviews = data['reviews'] ?? [];
        _averageRating = (data['averageRating'] as num?)?.toDouble() ?? 4.8;
        _totalReviews = data['totalReviews'] ?? 0;
        _isLoadingReviews = false;
      });
    } else if (mounted) {
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER WITH BACKGROUND ---
            Stack(
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
                Container(height: 300, color: blueMichelin.withOpacity(0.4)),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("UNLOCK &", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                      Text("RIDE.", style: TextStyle(color: yellowMichelin, fontSize: 36, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic)),
                    ],
                  ),
                )
              ],
            ),

            // --- STRAVA CARD ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: const ListTile(
                  leading: Icon(Icons.check_circle_outline, color: blueMichelin),
                  title: Text("Michelin Gravel Challenge — 102.4 km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text("DÉFI VALIDÉ - STRAVA", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  trailing: Text("⭐ 4,871\n RIDERS", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            // --- COUNTDOWN ---
            const Text("• L'OFFRE EXPIRE DANS •", style: TextStyle(color: blueMichelin, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox("47", "HEURES"),
                const Text(" : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: blueMichelin)),
                _buildTimeBox("21", "MIN"),
                const Text(" : ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: blueMichelin)),
                _buildTimeBox("06", "SEC"),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
              child: Text("Ce lien est unique. Il expire dans 48h ou dès épuisement du stock.", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
            ),
            const Divider(color: borderGrey),

            // --- TABS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  _buildTabButton("ROUTE", false),
                  _buildTabButton("GRAVEL", true),
                  _buildTabButton("URBAIN", false),
                ],
              ),
            ),

            // --- PRODUCT CARD ---
            Padding(
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
                        Image.network('https://images.unsplash.com/photo-1517649763962-0c623066013b', height: 200, width: double.infinity, fit: BoxFit.cover),
                        Positioned(
                          top: 12, left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            color: yellowMichelin,
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
                          const Text("POWER GRAVEL", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: blueMichelin, letterSpacing: -0.5)),
                          const SizedBox(height: 4),
                          const Text("Pack Gravel — 2 pneus + chambre à air + casquette", style: TextStyle(color: textMuted, fontSize: 13)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text("94 €", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: blueMichelin)),
                                  const SizedBox(width: 8),
                                  Text("142 €", style: TextStyle(fontSize: 14, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: yellowMichelin, borderRadius: BorderRadius.circular(2)),
                                child: const Text("-34%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // --- STOCK BAR ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("STOCK DROP", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blueMichelin)),
                  Text("33% restant", style: TextStyle(fontSize: 11, color: blueMichelin, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(value: 0.67, backgroundColor: Color(0xFFE2E8F0), color: yellowMichelin, minHeight: 8),
              ),
            ),
            const SizedBox(height: 20),

            // --- TECHNOLOGIE ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Align(alignment: Alignment.centerLeft, child: Text("TECHNOLOGIE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blueMichelin))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(color: bgLight, border: Border.all(color: borderGrey), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    _buildSpecRow(Icons.bolt, "Résistance au roulement", "Ultra-Low (3/3)"),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider(height: 1, color: borderGrey)),
                    _buildSpecRow(Icons.shield_outlined, "Protection", "ProTek+ 5 mm"),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider(height: 1, color: borderGrey)),
                    _buildSpecRow(Icons.swap_calls, "Dimension", "700x40c / 650b-47"),
                  ],
                ),
              ),
            ),

            // --- BORDURE DESCRIPTION ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: const BoxDecoration(border: Border(left: BorderSide(color: yellowMichelin, width: 4.0))),
                child: const Text(
                  "Conçu pour les terrains mixtes — asphalte et gravier — le Power Gravel offre la polyvalence que tu attends sans compromis sur la vitesse. Simple. Efficace. Michelin.",
                  style: TextStyle(fontSize: 13.0, color: Color(0xFF334155), height: 1.4),
                ),
              ),
            ),

            // --- SECTION LA COMMUNAUTÉ (TITRE + BADGE NOTE DYNAMIQUE) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("LA COMMUNAUTÉ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blueMichelin)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFFFFBEB), border: Border.all(color: const Color(0xFFFDE68A)), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                        const SizedBox(width: 4),
                        Text("$_averageRating", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                        Text(" · $_totalReviews avis", style: const TextStyle(fontSize: 11, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- LISTE DES AVIS CLIENTS (DYNAMIQUE) ---
            if (_isLoadingReviews)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: blueMichelin),
              )
            else if (_reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Aucun avis disponible pour ce produit.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              )
            else
              Column(
                children: _reviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: _buildReviewCard(
                      review['author'] ?? 'Anonyme',
                      review['initial'] ?? 'U',
                      '"${review['text'] ?? ''}"',
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

            // --- FOOTER BRAND ---
            Container(
              color: blueMichelin, width: double.infinity, padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.directions_bike, color: yellowMichelin, size: 40),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
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
            ),
          ],
        ),
      ),

      // --- STICKY BUY BUTTON WITH REASSURANCE ---
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: yellowMichelin, foregroundColor: blueMichelin,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ACHETER MAINTENANT", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text("Paiement sécurisé · Livraison 48h · Retour gratuit", style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildTimeBox(String value, String unit) {
    return Container(
      width: 60, padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: blueMichelin, borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(unit, style: const TextStyle(color: Colors.white, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isSelected ? blueMichelin : Colors.white, border: Border.all(color: borderGrey)),
        child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: blueMichelin),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: blueMichelin)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String initial, String reviewText) {
    return Card(
      elevation: 2, shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: const BorderSide(color: borderGrey, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, backgroundColor: blueMichelin, child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: blueMichelin)),
                const Spacer(),
                Row(children: List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14))),
              ],
            ),
            const SizedBox(height: 12),
            Text(reviewText, style: const TextStyle(fontSize: 13, color: Color(0xFF475569))),
          ],
        ),
      ),
    );
  }
}