import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MichelinDropPage extends StatefulWidget {
  const MichelinDropPage({Key? key}) : super(key: key);

  @override
  State<MichelinDropPage> createState() => _MichelinDropPageState();
}

class _MichelinDropPageState extends State<MichelinDropPage> {
  // Déclaration des couleurs de la charte Michelin
  static const Color blueMichelin = Color(0xFF1C4494);
  static const Color yellowMichelin = Color(0xFFFFF000);
  static const Color textMuted = Color(0xFF5C76A6);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);

  // Variables d'état globales
  String _currentDropId = 'drop-gravel-02'; // ID du drop courant
  String _selectedCategory = 'GRAVEL';            // Onglet par défaut

  String? _generatedCode;
  bool _isGeneratingCode = false;

  // États liés aux Packs
  List<dynamic> _packs = [];
  Map<String, dynamic>? _selectedPack;
  bool _isLoadingPacks = true;

  // États liés aux Avis du Pack sélectionné
  List<dynamic> _reviews = [];
  double _averageRating = 4.8;
  int _totalReviews = 0;
  bool _isLoadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadDropPacks(); // Charge les packs de la catégorie par défaut au démarrage
  }

  // 1. Récupère les packs filtrés par catégorie depuis l'API
  void _loadDropPacks() async {
    setState(() {
      _isLoadingPacks = true;
    });

    final packsData = await ApiService().getDropPacks(_currentDropId, category: _selectedCategory);

    if (packsData != null && packsData.isNotEmpty && mounted) {
      setState(() {
        _packs = packsData;
        _isLoadingPacks = false;
      });
      // Par défaut, on sélectionne et charge les avis du premier pack retourné
      _onPackSelected(packsData[0]);
    } else if (mounted) {
      setState(() {
        _packs = [];
        _selectedPack = null;
        _reviews = [];
        _isLoadingPacks = false;
      });
    }
  }

  // 2. Action au clic sur un Pack : charge dynamiquement ses données et ses avis associés
  void _onPackSelected(Map<String, dynamic> pack) async {
    setState(() {
      _selectedPack = pack;
      _isLoadingReviews = true;
    });

    final reviewData = await ApiService().getProductReviews(pack['id']);

    if (reviewData != null && mounted) {
      setState(() {
        _reviews = reviewData['reviews'] ?? [];
        _averageRating = (reviewData['averageRating'] as num?)?.toDouble() ?? 4.8;
        _totalReviews = reviewData['totalReviews'] ?? 0;
        _isLoadingReviews = false;
      });
    } else if (mounted) {
      setState(() {
        _reviews = [];
        _isLoadingReviews = false;
      });
    }
  }

  // Changer de catégorie (ROUTE, GRAVEL, URBAIN) au clic sur les onglets
  void _onCategoryChanged(String category) {
    if (_selectedCategory == category) return;

    setState(() {
      _selectedCategory = category;

      // 👈 On adapte l'ID du drop selon l'onglet pour coller à ton seeder et à ta doc
      if (category == 'GRAVEL') {
        _currentDropId = 'drop-gravel-02';
      } else if (category == 'ROUTE') {
        _currentDropId = 'drop-route-01';
      } else if (category == 'URBAIN') {
        _currentDropId = 'drop-urbain-03';
      }
    });

    _loadDropPacks();
  }

  void _handleGenerateCode() async {
    if (_selectedPack == null) return;

    setState(() {
      _isGeneratingCode = true;
    });

    final result = await ApiService().generatePackCode(_selectedPack!['id']);

    if (mounted) {
      setState(() {
        _isGeneratingCode = false;
      });

      if (result != null) {
        setState(() {
          _generatedCode = result['code'];
        });

        // Affiche un joli Pop-up avec le code de réduction
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("VOTRE CODE EXCLUSIF", style: TextStyle(color: blueMichelin, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Présentez ce code en magasin ou sur le site Michelin pour débloquer votre offre."),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: yellowMichelin.withOpacity(0.2),
                      border: Border.all(color: yellowMichelin, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _generatedCode!,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: blueMichelin),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "⌛ Valide pendant 48 heures uniquement.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("FERMER", style: TextStyle(color: blueMichelin, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 👈 Sécurité Écran Blanc : Affiche un loader global si les données initiales ne sont pas encore prêtes
    if (_isLoadingPacks && _selectedPack == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: blueMichelin),
        ),
      );
    }

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
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("UNLOCK &", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      Text("RIDE.", style: TextStyle(color: yellowMichelin, fontSize: 36, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
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

            // --- TABS (FILTRE DYNAMIQUE PAR CATÉGORIE) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  _buildTabButton("ROUTE", _selectedCategory == "ROUTE"),
                  _buildTabButton("GRAVEL", _selectedCategory == "GRAVEL"),
                  _buildTabButton("URBAIN", _selectedCategory == "URBAIN"),
                ],
              ),
            ),

            // --- LISTE DES PACKS SÉLECTIONNABLES ---
            if (_packs.isEmpty && !_isLoadingPacks)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Aucun pack disponible dans cette catégorie.", style: TextStyle(color: Colors.grey, fontSize: 13)),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("CHOISISSEZ VOTRE PACK :", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
                    const SizedBox(height: 8),
                    Row(
                      children: _packs.map((pack) {
                        bool isCurrent = _selectedPack?['id'] == pack['id'];
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: OutlinedButton(
                              onPressed: () => _onPackSelected(pack),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isCurrent ? blueMichelin.withOpacity(0.05) : Colors.white,
                                side: BorderSide(color: isCurrent ? blueMichelin : borderGrey, width: isCurrent ? 2 : 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text(
                                pack['name'] ?? '',
                                style: TextStyle(color: isCurrent ? blueMichelin : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // --- CARTE DU PRODUIT SÉLECTIONNÉ ---
            if (_selectedPack != null) ...[
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
                          Image.network(
                            _selectedPack!['imageUrl'] ?? 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            // 👈 Ce constructeur intercepte l'erreur CORS ou d'URL cassée vue sur image_e418fc.png
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://images.unsplash.com/photo-1517649763962-0c623066013b', // Image de secours fiable
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
                            Text(_selectedPack!['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: blueMichelin, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text(_selectedPack!['subtitle'] ?? '', style: const TextStyle(color: textMuted, fontSize: 13)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text("${_selectedPack!['price']} €", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: blueMichelin)),
                                    const SizedBox(width: 8),
                                    Text("${_selectedPack!['originalPrice']} €", style: TextStyle(fontSize: 14, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: yellowMichelin, borderRadius: BorderRadius.circular(2)),
                                  child: Text("-${_selectedPack!['discountPercentage']}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black)),
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

              // --- STOCK BAR DYNAMIQUE ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("STOCK DROP", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blueMichelin)),
                    Text("${_selectedPack!['stock']?['remainingPercentage'] ?? 0}% restant", style: const TextStyle(fontSize: 11, color: blueMichelin, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                      value: ((_selectedPack!['stock']?['remainingPercentage'] ?? 0) / 100).toDouble(),
                      backgroundColor: const Color(0xFFE2E8F0), color: yellowMichelin, minHeight: 8
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- TECHNOLOGIES DYNAMIQUES DE L'API ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Align(alignment: Alignment.centerLeft, child: Text("TECHNOLOGIE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: blueMichelin))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(color: bgLight, border: Border.all(color: borderGrey), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: (_selectedPack!['technologies'] as List<dynamic>? ?? []).map<Widget>((tech) {
                      IconData techIcon = Icons.star_border;
                      if (tech['icon'] == 'bolt') techIcon = Icons.bolt;
                      if (tech['icon'] == 'shield') techIcon = Icons.shield_outlined;
                      if (tech['icon'] == 'straighten') techIcon = Icons.straighten;

                      return Column(
                        children: [
                          _buildSpecRow(techIcon, tech['label'] ?? '', tech['value'] ?? ''),
                          if (tech != (_selectedPack!['technologies'] as List).last)
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Divider(height: 1, color: borderGrey)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // --- BORDURE DESCRIPTION ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                  decoration: const BoxDecoration(border: Border(left: BorderSide(color: yellowMichelin, width: 4.0))),
                  child: Text(
                    _selectedPack!['description'] ?? '',
                    style: const TextStyle(fontSize: 13.0, color: Color(0xFF334155), height: 1.4),
                  ),
                ),
              ),
            ],

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

            // --- LISTE DES AVIS CLIENTS (DYNAMIQUE AU CLIC SUR LE PACK) ---
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

      // --- STICKY BUY BUTTON ---
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: (_selectedPack == null || _isGeneratingCode) ? null : _handleGenerateCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: blueMichelin, // On passe en bleu Michelin pour changer le style du bouton d'action
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                elevation: 0,
              ),
              child: _isGeneratingCode
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, color: yellowMichelin),
                  SizedBox(width: 10),
                  Text("GÉNÉRER UN CODE POUR CE PACK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: yellowMichelin)),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: yellowMichelin),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text("Code unique réservé aux membres Strava éligibles · Validité 48h", style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500)),
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
      child: InkWell(
        onTap: () => _onCategoryChanged(text), // Filtre sur l'API au changement d'onglet
        child: Container(
          alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? blueMichelin : Colors.white, border: Border.all(color: borderGrey)),
          child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
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
                CircleAvatar(
                    radius: 14,
                    backgroundColor: blueMichelin,
                    child: Text(initial.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                ),
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