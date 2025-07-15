import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final Future<List<Produit>> futureProduits;
  final Function(Produit)? onProductTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int crossAxisCount;

  const ProductGrid({
    super.key,
    required this.futureProduits,
    this.onProductTap,
    this.shrinkWrap = false,
    this.physics,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucun produit disponible',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final produits = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.57,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
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