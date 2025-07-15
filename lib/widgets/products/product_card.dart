import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/cart/cart_page.dart';
import 'package:gestioncoop/widgets/common/CustomProductNotification.dart';
import 'package:provider/provider.dart';
import 'package:gestioncoop/providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Produit produit;
  final VoidCallback? onTap;
  final bool showDiscountBadge;

  const ProductCard({
    super.key,
    required this.produit,
    this.onTap,
    this.showDiscountBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    final discountPercentage =
        produit.originalPrice != null && produit.originalPrice! > produit.prix
            ? (((produit.originalPrice! - produit.prix) /
                        produit.originalPrice!) *
                    100)
                .round()
            : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 360),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image et badges
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: produit.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor,
                              ),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  if (showDiscountBadge && discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (produit.isBio || produit.isEco || produit.fairTrade)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (produit.isBio) _buildBadge('BIO', Colors.green),
                          if (produit.isEco) _buildBadge('ECO', Colors.blue),
                          if (produit.fairTrade)
                            _buildBadge('FAIR', Colors.orange),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Texte
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produit.libelle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: produit.averageRating,
                          itemBuilder:
                              (context, _) =>
                                  Icon(Icons.star, color: primaryColor),
                          itemCount: 5,
                          itemSize: 14,
                          unratedColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${produit.totalReviews})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${produit.soldCount} vendus',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${produit.prix.toStringAsFixed(2)} DHS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (produit.originalPrice != null &&
                            produit.originalPrice! > produit.prix)
                          Text(
                            '${produit.originalPrice!.toStringAsFixed(2)} DHS',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                          color:
                              produit.isFreeShipping
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          produit.isFreeShipping
                              ? 'Livraison gratuite'
                              : 'Frais de livraison',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                produit.isFreeShipping
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stock: ${produit.qteStock}',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                produit.qteStock > 0
                                    ? Colors.grey[600]
                                    : Colors.red,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 20),
                          color: primaryColor,
                          tooltip: 'Ajouter au panier',
                          onPressed: () {
                            final cartProvider = Provider.of<CartProvider>(
                              context,
                              listen: false,
                            );
                            cartProvider.addToCart(produit);

                            // Afficher la notification personnalisée
                            OverlayEntry? overlayEntry;
                            overlayEntry = OverlayEntry(
                              builder:
                                  (context) => Positioned(
                                    top:
                                        MediaQuery.of(context).padding.top + 10,
                                    left: 10,
                                    right: 10,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: CustomProductNotification(
                                        productName: produit.libelle,
                                        imageUrl: produit.image,
                                        onViewCart: () {
                                          // Navigation vers le panier
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const CartPage(),
                                            ),
                                          );
                                          overlayEntry?.remove();
                                        },
                                      ),
                                    ),
                                  ),
                            );

                            // Ajouter l'overlay
                            Overlay.of(context).insert(overlayEntry);

                            // Retirer automatiquement après 3 secondes
                            Future.delayed(const Duration(seconds: 3), () {
                              overlayEntry?.remove();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
