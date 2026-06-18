import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/michelin_theme.dart';
import '../widgets/header_section.dart';
import '../widgets/strava_challenge_card.dart';
import '../widgets/countdown_section.dart';
import '../widgets/category_tabs.dart';
import '../widgets/pack_selector.dart';
import '../widgets/product_card.dart';
import '../widgets/stock_bar.dart';
import '../widgets/technology_section.dart';
import '../widgets/review_card.dart';
import '../widgets/footer_brand.dart';

class MichelinDropPage extends StatefulWidget {
  const MichelinDropPage({Key? key}) : super(key: key);

  @override
  State<MichelinDropPage> createState() => _MichelinDropPageState();
}

class _MichelinDropPageState extends State<MichelinDropPage> {
  // Variables d'état globales
  String _currentDropId = 'drop-gravel-02'; // ID du drop courant
  String _selectedCategory = 'GRAVEL';            // Onglet par défaut

  String? _generatedCode;
  bool _isGeneratingCode = false;

  // Liste mockée des défis Strava
  final List<Map<String, dynamic>> _stravaChallenges = [
    {
      'id': 'challenge-gravel-100',
      'title': 'Michelin Gravel Challenge — 102.4 km',
      'type': 'GRAVEL',
      'isCompleted': true,
      'completedAt': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'hasGeneratedCode': false,
      'participantsCount': 4871,
      'statusText': 'DÉFI VALIDÉ - STRAVA',
    },
    {
      'id': 'challenge-route-classic',
      'title': 'Michelin Route Sprint — 50 km',
      'type': 'ROUTE',
      'isCompleted': false,
      'completedAt': null,
      'hasGeneratedCode': false,
      'participantsCount': 1243,
      'statusText': 'EN COURS - 32 km / 50 km',
    },
    {
      'id': 'challenge-urbain-velotaf',
      'title': 'Michelin Urbain Commuter — 20 km',
      'type': 'URBAIN',
      'isCompleted': false,
      'completedAt': null,
      'hasGeneratedCode': false,
      'participantsCount': 854,
      'statusText': 'EN COURS - 5 km / 20 km',
    },
  ];

  // États liés aux Packs
  List<dynamic> _packs = [];
  Map<String, dynamic>? _selectedPack;
  bool _isLoadingPacks = true;

  // États liés aux Avis
  List<dynamic> _reviews = [];
  double _averageRating = 4.8;
  int _totalReviews = 0;
  bool _isLoadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadDropPacks();
  }

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

  void _onCategoryChanged(String category) {
    if (_selectedCategory == category) return;

    setState(() {
      _selectedCategory = category;
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
          final currentChallenge = _stravaChallenges.firstWhere(
                (c) => c['type'] == _selectedCategory,
            orElse: () => {},
          );
          if (currentChallenge.isNotEmpty) {
            currentChallenge['hasGeneratedCode'] = true;
          }
        });

        _showCodeDialog();
      }
    }
  }

  void _showCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("VOTRE CODE EXCLUSIF", style: TextStyle(color: MichelinTheme.blueMichelin, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Présentez ce code en magasin ou sur le site Michelin pour débloquer votre offre."),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MichelinTheme.yellowMichelin.withOpacity(0.2),
                  border: Border.all(color: MichelinTheme.yellowMichelin, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _generatedCode!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: MichelinTheme.blueMichelin),
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
              child: const Text("FERMER", style: TextStyle(color: MichelinTheme.blueMichelin, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPacks && _selectedPack == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: MichelinTheme.blueMichelin)),
      );
    }

    final currentChallenge = _stravaChallenges.firstWhere(
          (c) => c['type'] == _selectedCategory,
      orElse: () => _stravaChallenges.first,
    );

    bool isChallengeCompleted = currentChallenge['isCompleted'] ?? false;
    bool alreadyGenerated = currentChallenge['hasGeneratedCode'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderSection(),
            StravaChallengeCard(challenge: currentChallenge),
            CountdownSection(completedAt: currentChallenge['completedAt'] as DateTime?),
            const Divider(color: MichelinTheme.borderGrey),
            CategoryTabs(
              selectedCategory: _selectedCategory,
              onCategoryChanged: _onCategoryChanged,
            ),
            PackSelector(
              packs: _packs,
              selectedPack: _selectedPack,
              onPackSelected: _onPackSelected,
            ),
            if (_selectedPack != null) ...[
              ProductCard(pack: _selectedPack!),
              StockBar(remainingPercentage: _selectedPack!['stock']?['remainingPercentage'] ?? 0),
              const SizedBox(height: 20),
              TechnologySection(technologies: _selectedPack!['technologies'] as List<dynamic>? ?? []),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                  decoration: const BoxDecoration(border: Border(left: BorderSide(color: MichelinTheme.yellowMichelin, width: 4.0))),
                  child: Text(
                    _selectedPack!['description'] ?? '',
                    style: const TextStyle(fontSize: 13.0, color: Color(0xFF334155), height: 1.4),
                  ),
                ),
              ),
            ],
            _buildCommunityHeader(),
            _buildReviewsList(),
            const SizedBox(height: 30),
            FooterBrand(onShare: () {}),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(isChallengeCompleted, alreadyGenerated),
    );
  }

  Widget _buildCommunityHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("LA COMMUNAUTÉ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: MichelinTheme.blueMichelin)),
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
    );
  }

  Widget _buildReviewsList() {
    if (_isLoadingReviews) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(color: MichelinTheme.blueMichelin),
      );
    }
    if (_reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Aucun avis disponible pour ce produit.", style: TextStyle(color: Colors.grey, fontSize: 13)),
      );
    }
    return Column(
      children: _reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ReviewCard(
            author: review['author'] ?? 'Anonyme',
            initial: review['initial'] ?? 'U',
            text: review['text'] ?? '',
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActions(bool isChallengeCompleted, bool alreadyGenerated) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: (_selectedPack == null || _isGeneratingCode || !isChallengeCompleted || alreadyGenerated)
                ? null
                : _handleGenerateCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: alreadyGenerated ? Colors.grey.shade400 : MichelinTheme.blueMichelin,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
            child: _isGeneratingCode
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  alreadyGenerated ? Icons.lock_outline : Icons.qr_code_2,
                  color: alreadyGenerated ? Colors.white70 : MichelinTheme.yellowMichelin,
                ),
                const SizedBox(width: 10),
                Text(
                  alreadyGenerated
                      ? "CODE DÉJÀ GÉNÉRÉ POUR CE DÉFI"
                      : (!isChallengeCompleted ? "DÉFI EN COURS SUR STRAVA" : "GÉNÉRER UN CODE POUR CE PACK"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: alreadyGenerated ? Colors.white70 : MichelinTheme.yellowMichelin,
                  ),
                ),
                if (!alreadyGenerated && isChallengeCompleted) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: MichelinTheme.yellowMichelin),
                ]
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text("Code unique réservé aux membres Strava éligibles · Validité 48h", style: TextStyle(fontSize: 10, color: MichelinTheme.textMuted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
