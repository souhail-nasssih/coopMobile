import 'package:flutter/material.dart';
import 'package:gestioncoop/models/GrandCategory.dart';
import 'package:gestioncoop/screens/product_by_categorie/product_by_categorie.dart';
import 'package:gestioncoop/services/category_service.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryService _categoryService = CategoryService();

  void _navigateToProducts(int categoryId, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductByCategorie(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: FutureBuilder<List<GrandCategory>>(
        future: _categoryService.fetchGrandCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: const TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune catégorie disponible',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final categories = snapshot.data!;
          final responsive = Responsive(context);

          return Padding(
            padding: responsive.padding(
              mobile: const EdgeInsets.all(16),
              tablet: const EdgeInsets.all(24),
              desktop: const EdgeInsets.all(32),
            ),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: responsive.columns(
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                ),
                crossAxisSpacing: responsive.spacing(
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                mainAxisSpacing: responsive.spacing(
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                childAspectRatio: responsive.adaptive(
                  mobile: 0.9,
                  tablet: 1.0,
                  desktop: 1.1,
                ),
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryCard(
                  category: category,
                  onTap: () => _navigateToProducts(category.id, category.name),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final GrandCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final color = _getCategoryColor(category.id);
    final icon = _getCategoryIcon(category.id);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: responsive.padding(
              mobile: const EdgeInsets.all(20),
              tablet: const EdgeInsets.all(24),
              desktop: const EdgeInsets.all(28),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    responsive.adaptive(mobile: 20, tablet: 24, desktop: 28),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: responsive.adaptive(mobile: 36, tablet: 42, desktop: 48),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: responsive.spacing(mobile: 16, tablet: 20, desktop: 24),
                ),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: responsive.fontSize(mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(int id) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[id % colors.length];
  }

  IconData _getCategoryIcon(int id) {
    final icons = [
      Icons.category,
      Icons.shopping_bag,
      Icons.home_filled,
      Icons.eco,
      Icons.fastfood,
      Icons.devices_other,
    ];
    return icons[id % icons.length];
  }
}