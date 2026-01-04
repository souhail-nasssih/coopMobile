import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/helpers/responsive.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final Future<List<Produit>> futureProduits;
  final Function(Produit)? onProductTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int? crossAxisCount;

  const ProductGrid({
    super.key,
    required this.futureProduits,
    this.onProductTap,
    this.shrinkWrap = false,
    this.physics,
    this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return FutureBuilder<List<Produit>>(
      future: futureProduits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: responsive.adaptive(mobile: 50, tablet: 64),
                  color: Colors.grey[400],
                ),
                SizedBox(height: responsive.spacing(mobile: 16, tablet: 20)),
                Text(
                  'Aucun produit disponible',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                  ),
                ),
              ],
            ),
          );
        }

        final produits = snapshot.data!;
        
        // Nombre de colonnes adaptatif
        final columns = crossAxisCount ?? responsive.columns(
          mobile: 2,
          tablet: 3,
          desktop: 4,
        );
        
        // Aspect ratio adaptatif
        final aspectRatio = responsive.adaptive(
          mobile: 0.57,
          tablet: 0.65,
          desktop: 0.7,
        );
        
        // Espacement adaptatif
        final spacing = responsive.spacing(
          mobile: 12,
          tablet: 16,
          desktop: 20,
        );
        
        // Padding adaptatif
        final padding = responsive.padding(
          mobile: const EdgeInsets.all(10),
          tablet: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(20),
        );

        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: produits.length,
          itemBuilder: (context, index) {
            return ProductCard(
              produit: produits[index],
              onTap: () => onProductTap?.call(produits[index]),
              showDiscountBadge: true,
            );
          },
        );
      },
    );
  }
}