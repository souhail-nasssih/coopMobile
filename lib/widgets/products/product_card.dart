import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/cart/cart_page.dart';
import 'package:gestioncoop/widgets/common/CustomProductNotification.dart';
import 'package:gestioncoop/widgets/common/images.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';
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
    final responsive = Responsive(context);

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
        constraints: BoxConstraints(
          minHeight: responsive.adaptive(mobile: 320, tablet: 360, desktop: 400),
          maxHeight: responsive.adaptive(mobile: 400, tablet: 450, desktop: 500),
        ),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image et badges
            SizedBox(
              height: responsive.adaptive(mobile: 150, tablet: 180, desktop: 200),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.radiusLarge),
                    ),
                    child: _buildProductImage(primaryColor),
                  ),
                  if (showDiscountBadge && discountPercentage > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE53935), Color(0xFFC62828)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: AppTheme.subtleShadow,
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
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
                padding: responsive.padding(
                  mobile: const EdgeInsets.all(10),
                  tablet: const EdgeInsets.all(12),
                  desktop: const EdgeInsets.all(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            produit.libelle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: responsive.fontSize(mobile: 14, tablet: 15, desktop: 16),
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: responsive.spacing(mobile: 4, tablet: 6)),
                          Row(
                            children: [
                            RatingBarIndicator(
                              rating: produit.averageRating,
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rounded,
                                color: primaryColor,
                                size: responsive.adaptive(mobile: 12, tablet: 14, desktop: 16),
                              ),
                              itemCount: 5,
                              itemSize: responsive.adaptive(mobile: 12, tablet: 14, desktop: 16),
                              unratedColor: Colors.grey[300],
                            ),
                            SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
                            Flexible(
                              child: Text(
                                '(${produit.totalReviews})',
                                style: TextStyle(
                                  fontSize: responsive.fontSize(mobile: 10, tablet: 11, desktop: 12),
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${produit.prix.toStringAsFixed(2)} DHS',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor,
                                  letterSpacing: -0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (produit.originalPrice != null &&
                                produit.originalPrice! > produit.prix)
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    '${produit.originalPrice!.toStringAsFixed(2)} DHS',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: produit.isFreeShipping
                                      ? AppTheme.successColor.withOpacity(0.15)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_shipping_rounded,
                                      size: 10,
                                      color: produit.isFreeShipping
                                          ? AppTheme.successColor
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      produit.isFreeShipping ? 'Gratuit' : 'Payant',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: produit.isFreeShipping
                                            ? AppTheme.successColor
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: produit.qteStock > 0
                                      ? AppTheme.successColor.withOpacity(0.15)
                                      : AppTheme.errorColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  produit.qteStock > 0 ? 'En stock' : 'Rupture',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: produit.qteStock > 0
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.85),
                                primaryColor.withOpacity(0.75),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                );
                                cartProvider.addToCart(produit);

                                OverlayEntry? overlayEntry;
                                overlayEntry = OverlayEntry(
                                  builder: (context) => Positioned(
                                    top: MediaQuery.of(context).padding.top + 10,
                                    left: 10,
                                    right: 10,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: CustomProductNotification(
                                        productName: produit.libelle,
                                        imageUrl: fixImageUrl(produit.image),
                                        onViewCart: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const CartPage(),
                                            ),
                                          );
                                          overlayEntry?.remove();
                                        },
                                      ),
                                    ),
                                  ),
                                );

                                Overlay.of(context).insert(overlayEntry);
                                Future.delayed(const Duration(seconds: 3), () {
                                  overlayEntry?.remove();
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: responsive.adaptive(mobile: 12, tablet: 14, desktop: 16),
                                  horizontal: responsive.adaptive(mobile: 16, tablet: 20, desktop: 24),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        responsive.adaptive(mobile: 4, tablet: 5, desktop: 6),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart_rounded,
                                        color: Colors.white,
                                        size: responsive.adaptive(mobile: 18, tablet: 20, desktop: 22),
                                      ),
                                    ),
                                    SizedBox(width: responsive.spacing(mobile: 8, tablet: 10)),
                                    Flexible(
                                      child: Text(
                                        'Ajouter',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.fontSize(mobile: 14, tablet: 15, desktop: 16),
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProductImage(Color primaryColor) {
    // Si l'image est vide, utiliser directement le placeholder local
    if (produit.image.isEmpty) {
      return buildDefaultProductPlaceholder(
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }
    
    final imageUrl = fixImageUrl(produit.image);
    
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 150,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        print('Erreur de chargement d\'image: $error pour URL: $url');
        // Utiliser le placeholder local au lieu d'essayer de charger depuis le serveur
        return buildDefaultProductPlaceholder(
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
