import 'package:flutter/material.dart';
import '../theme/michelin_theme.dart';

class CategoryTabs extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryTabs({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          _buildTabButton("ROUTE", selectedCategory == "ROUTE"),
          _buildTabButton("GRAVEL", selectedCategory == "GRAVEL"),
          _buildTabButton("URBAIN", selectedCategory == "URBAIN"),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => onCategoryChanged(text),
        child: Container(
          alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? MichelinTheme.blueMichelin : Colors.white,
            border: Border.all(color: MichelinTheme.borderGrey),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
