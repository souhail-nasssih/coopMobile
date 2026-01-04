import 'package:flutter/material.dart';
import 'package:gestioncoop/screens/cart/CartItem.dart';
import 'package:provider/provider.dart';
import 'package:gestioncoop/providers/cart_provider.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/widgets/common/images.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final responsive = Responsive(context);
    final freeShippingThreshold = 100.0;
    final remainingForFreeShipping =
        freeShippingThreshold - cartProvider.totalPrice;
    final hasFreeShipping =
        cartProvider.items.any((item) => item.produit.isFreeShipping) ||
        cartProvider.totalPrice >= freeShippingThreshold;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Mon Panier',
              style: TextStyle(
                fontSize: responsive.fontSize(mobile: 20, tablet: 22, desktop: 24),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            if (cartProvider.items.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cartProvider.items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              onPressed: () => _showClearCartDialog(context, cartProvider),
              tooltip: 'Vider le panier',
            ),
          SizedBox(width: responsive.spacing(mobile: 8, tablet: 12)),
        ],
      ),
      body: _buildBody(
        context,
        cartProvider,
        responsive,
        hasFreeShipping,
        remainingForFreeShipping,
        freeShippingThreshold,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CartProvider cartProvider,
    Responsive responsive,
    bool hasFreeShipping,
    double remainingForFreeShipping,
    double freeShippingThreshold,
  ) {
    if (cartProvider.items.isEmpty) {
      return _buildEmptyCart(context, responsive);
    }

    return Column(
      children: [
        // Bannière promotionnelle moderne
        _buildPromoBanner(
          context,
          responsive,
          hasFreeShipping,
          remainingForFreeShipping,
          cartProvider,
          freeShippingThreshold,
        ),

        // Liste des produits
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(responsive.spacing(mobile: 12, tablet: 16)),
            itemCount: cartProvider.items.length,
            separatorBuilder: (context, index) => SizedBox(
              height: responsive.spacing(mobile: 12, tablet: 16),
            ),
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return _buildCartItem(context, item, cartProvider, responsive);
            },
          ),
        ),

        // Résumé et bouton de commande
        _buildCheckoutSummary(context, cartProvider, hasFreeShipping, responsive),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context, Responsive responsive) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.spacing(mobile: 24, tablet: 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(responsive.adaptive(mobile: 40, tablet: 50)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.primaryOrange.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: responsive.adaptive(mobile: 80, tablet: 100),
                color: AppTheme.primaryGreen,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 24, tablet: 32)),
            Text(
              'Votre panier est vide',
              style: TextStyle(
                fontSize: responsive.fontSize(mobile: 24, tablet: 28, desktop: 32),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
            Text(
              'Parcourez nos produits et ajoutez-les à votre panier',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 32, tablet: 40)),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(
                  responsive.adaptive(mobile: 16, tablet: 20),
                ),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(
                    responsive.adaptive(mobile: 16, tablet: 20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.adaptive(mobile: 32, tablet: 40),
                      vertical: responsive.adaptive(mobile: 16, tablet: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        SizedBox(width: responsive.spacing(mobile: 8, tablet: 12)),
                        Text(
                          'Découvrir les produits',
                          style: TextStyle(
                            fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
    );
  }

  Widget _buildPromoBanner(
    BuildContext context,
    Responsive responsive,
    bool hasFreeShipping,
    double remainingForFreeShipping,
    CartProvider cartProvider,
    double freeShippingThreshold,
  ) {
    return Container(
      margin: EdgeInsets.all(responsive.spacing(mobile: 12, tablet: 16)),
      padding: EdgeInsets.all(responsive.spacing(mobile: 16, tablet: 20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasFreeShipping
              ? [
                  AppTheme.successColor.withOpacity(0.15),
                  AppTheme.successColor.withOpacity(0.08),
                ]
              : [
                  AppTheme.warningColor.withOpacity(0.15),
                  AppTheme.warningColor.withOpacity(0.08),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          responsive.adaptive(mobile: 16, tablet: 20),
        ),
        border: Border.all(
          color: hasFreeShipping
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.warningColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasFreeShipping
                      ? AppTheme.successColor
                      : AppTheme.warningColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  hasFreeShipping
                      ? Icons.local_shipping_rounded
                      : Icons.local_offer_rounded,
                  color: Colors.white,
                  size: responsive.adaptive(mobile: 20, tablet: 24),
                ),
              ),
              SizedBox(width: responsive.spacing(mobile: 12, tablet: 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasFreeShipping
                          ? 'Livraison gratuite activée !'
                          : 'Plus que ${remainingForFreeShipping.toStringAsFixed(2)} DHS',
                      style: TextStyle(
                        fontSize: responsive.fontSize(mobile: 15, tablet: 17),
                        fontWeight: FontWeight.w700,
                        color: hasFreeShipping
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                      ),
                    ),
                    if (!hasFreeShipping)
                      Text(
                        'pour la livraison gratuite',
                        style: TextStyle(
                          fontSize: responsive.fontSize(mobile: 12, tablet: 14),
                          color: AppTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (!hasFreeShipping) ...[
            SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: cartProvider.totalPrice / freeShippingThreshold,
                    minHeight: responsive.adaptive(mobile: 8, tablet: 10),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.warningColor),
                  ),
                ),
                SizedBox(height: responsive.spacing(mobile: 6, tablet: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cartProvider.totalPrice.toStringAsFixed(2)} DHS',
                      style: TextStyle(
                        fontSize: responsive.fontSize(mobile: 12, tablet: 14),
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${freeShippingThreshold.toStringAsFixed(2)} DHS',
                      style: TextStyle(
                        fontSize: responsive.fontSize(mobile: 12, tablet: 14),
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartProvider cartProvider,
    Responsive responsive,
  ) {
    final produit = item.produit;
    final hasDiscount =
        produit.originalPrice != null && produit.originalPrice! > produit.prix;
    final totalItemPrice = produit.prix * item.quantity;

    return Dismissible(
      key: Key(produit.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(
          bottom: responsive.spacing(mobile: 12, tablet: 16),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.errorColor,
              AppTheme.errorColor.withOpacity(0.8),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(
            responsive.adaptive(mobile: 16, tablet: 20),
          ),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: responsive.spacing(mobile: 20, tablet: 24)),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        cartProvider.removeFromCart(produit);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produit.libelle} retiré du panier'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'Annuler',
              textColor: Colors.white,
              onPressed: () => cartProvider.addToCart(produit),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(responsive.spacing(mobile: 12, tablet: 16)),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(
            responsive.adaptive(mobile: 16, tablet: 20),
          ),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Container(
              width: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
              height: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  responsive.adaptive(mobile: 12, tablet: 16),
                ),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.adaptive(mobile: 12, tablet: 16),
                ),
                child: _buildProductImage(context, produit, responsive),
              ),
            ),

            SizedBox(width: responsive.spacing(mobile: 12, tablet: 16)),

            // Détails du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du produit
                  Text(
                    produit.libelle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: responsive.spacing(mobile: 6, tablet: 8)),

                  // Prix
                  Row(
                    children: [
                      Text(
                        '${produit.prix.toStringAsFixed(2)} DHS',
                        style: TextStyle(
                          fontSize: responsive.fontSize(mobile: 18, tablet: 20),
                          fontWeight: FontWeight.w800,
                          color: hasDiscount
                              ? AppTheme.errorColor
                              : AppTheme.primaryGreen,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: responsive.spacing(mobile: 8, tablet: 10)),
                        Text(
                          '${produit.originalPrice!.toStringAsFixed(2)} DHS',
                          style: TextStyle(
                            fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                            decoration: TextDecoration.lineThrough,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(width: responsive.spacing(mobile: 6, tablet: 8)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.errorColor,
                                AppTheme.errorColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${((produit.originalPrice! - produit.prix) / produit.originalPrice! * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontSize(mobile: 11, tablet: 12),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: responsive.spacing(mobile: 8, tablet: 10)),

                  // Badges
                  Wrap(
                    spacing: responsive.spacing(mobile: 6, tablet: 8),
                    runSpacing: responsive.spacing(mobile: 6, tablet: 8),
                    children: [
                      if (produit.isFreeShipping)
                        _buildBadge(
                          'Livraison gratuite',
                          Icons.local_shipping_rounded,
                          AppTheme.successColor,
                          responsive,
                        ),
                      if (produit.isBio)
                        _buildBadge('Bio', Icons.eco_rounded, AppTheme.successColor, responsive),
                      if (produit.isEco)
                        _buildBadge('Éco', Icons.recycling_rounded, AppTheme.infoColor, responsive),
                      if (produit.fairTrade)
                        _buildBadge('Fair Trade', Icons.verified_rounded, AppTheme.warningColor, responsive),
                    ],
                  ),

                  SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),

                  // Contrôle quantité et prix total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Contrôle quantité
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(
                            responsive.adaptive(mobile: 12, tablet: 14),
                          ),
                          border: Border.all(
                            color: AppTheme.primaryGreen.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => cartProvider.decrementQuantity(produit.id),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    responsive.adaptive(mobile: 12, tablet: 14),
                                  ),
                                  bottomLeft: Radius.circular(
                                    responsive.adaptive(mobile: 12, tablet: 14),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    responsive.adaptive(mobile: 8, tablet: 10),
                                  ),
                                  child: Icon(
                                    Icons.remove_rounded,
                                    size: responsive.adaptive(mobile: 18, tablet: 20),
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.adaptive(mobile: 12, tablet: 16),
                              ),
                              child: Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => cartProvider.incrementQuantity(produit.id),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    responsive.adaptive(mobile: 12, tablet: 14),
                                  ),
                                  bottomRight: Radius.circular(
                                    responsive.adaptive(mobile: 12, tablet: 14),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    responsive.adaptive(mobile: 8, tablet: 10),
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: responsive.adaptive(mobile: 18, tablet: 20),
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Prix total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: responsive.fontSize(mobile: 11, tablet: 12),
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: responsive.spacing(mobile: 2, tablet: 4)),
                          Text(
                            '${totalItemPrice.toStringAsFixed(2)} DHS',
                            style: TextStyle(
                              fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Stock
                  SizedBox(height: responsive.spacing(mobile: 8, tablet: 10)),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: responsive.adaptive(mobile: 14, tablet: 16),
                        color: produit.qteStock > 0
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                      SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
                      Text(
                        'Stock: ${produit.qteStock}',
                        style: TextStyle(
                          fontSize: responsive.fontSize(mobile: 12, tablet: 13),
                          color: produit.qteStock > 0
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(
    String text,
    IconData icon,
    Color color,
    Responsive responsive,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.adaptive(mobile: 8, tablet: 10),
        vertical: responsive.adaptive(mobile: 4, tablet: 6),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          responsive.adaptive(mobile: 8, tablet: 10),
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: responsive.adaptive(mobile: 12, tablet: 14),
            color: color,
          ),
          SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
          Text(
            text,
            style: TextStyle(
              fontSize: responsive.fontSize(mobile: 11, tablet: 12),
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary(
    BuildContext context,
    CartProvider cartProvider,
    bool hasFreeShipping,
    Responsive responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            responsive.adaptive(mobile: 24, tablet: 28),
          ),
        ),
      ),
      padding: EdgeInsets.all(responsive.spacing(mobile: 20, tablet: 24)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Résumé des prix
            _buildPriceRow(
              'Sous-total',
              '${cartProvider.totalPrice.toStringAsFixed(2)} DHS',
              responsive,
              isSecondary: true,
            ),
            SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
            _buildPriceRow(
              'Livraison',
              hasFreeShipping ? 'Gratuite' : 'À calculer',
              responsive,
              isSecondary: true,
              isFree: hasFreeShipping,
            ),
            SizedBox(height: responsive.spacing(mobile: 16, tablet: 20)),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
            SizedBox(height: responsive.spacing(mobile: 16, tablet: 20)),
            _buildPriceRow(
              'Total',
              '${cartProvider.totalPrice.toStringAsFixed(2)} DHS',
              responsive,
              isSecondary: false,
            ),
            SizedBox(height: responsive.spacing(mobile: 20, tablet: 24)),

            // Bouton de commande
            Container(
              width: double.infinity,
              height: responsive.adaptive(mobile: 56, tablet: 60, desktop: 64),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(
                  responsive.adaptive(mobile: 16, tablet: 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showOrderConfirmation(context, cartProvider, responsive),
                  borderRadius: BorderRadius.circular(
                    responsive.adaptive(mobile: 16, tablet: 20),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_rounded, color: Colors.white),
                        SizedBox(width: responsive.spacing(mobile: 10, tablet: 12)),
                        Text(
                          'Passer la commande',
                          style: TextStyle(
                            fontSize: responsive.fontSize(mobile: 18, tablet: 20),
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    Responsive responsive, {
    bool isSecondary = false,
    bool isFree = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.fontSize(
              mobile: isSecondary ? 15 : 20,
              tablet: isSecondary ? 17 : 22,
            ),
            fontWeight: isSecondary ? FontWeight.w500 : FontWeight.w800,
            color: isSecondary ? AppTheme.textSecondary : AppTheme.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: responsive.fontSize(
              mobile: isSecondary ? 15 : 22,
              tablet: isSecondary ? 17 : 24,
            ),
            fontWeight: isSecondary ? FontWeight.w600 : FontWeight.w900,
            color: isFree
                ? AppTheme.successColor
                : isSecondary
                    ? AppTheme.textPrimary
                    : AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.errorColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Vider le panier'),
          ],
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vider votre panier ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.errorColor, AppTheme.errorColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context);
              },
              child: const Text(
                'Vider',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(
    BuildContext context,
    CartProvider cartProvider,
    Responsive responsive,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(responsive.spacing(mobile: 24, tablet: 32)),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              responsive.adaptive(mobile: 28, tablet: 32),
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              SizedBox(height: responsive.spacing(mobile: 24, tablet: 32)),
              Container(
                padding: EdgeInsets.all(responsive.adaptive(mobile: 24, tablet: 32)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.successColor.withOpacity(0.2),
                      AppTheme.successColor.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: responsive.adaptive(mobile: 80, tablet: 100),
                  color: AppTheme.successColor,
                ),
              ),
              SizedBox(height: responsive.spacing(mobile: 24, tablet: 32)),
              Text(
                'Commande confirmée !',
                style: TextStyle(
                  fontSize: responsive.fontSize(mobile: 24, tablet: 28),
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
              Text(
                'Votre commande a été enregistrée avec succès',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: responsive.spacing(mobile: 32, tablet: 40)),
              Container(
                width: double.infinity,
                height: responsive.adaptive(mobile: 56, tablet: 60),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    responsive.adaptive(mobile: 16, tablet: 20),
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      cartProvider.clearCart();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    borderRadius: BorderRadius.circular(
                      responsive.adaptive(mobile: 16, tablet: 20),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Retour à l\'accueil',
                        style: TextStyle(
                          fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(
    BuildContext context,
    Produit produit,
    Responsive responsive,
  ) {
    if (produit.image.isEmpty) {
      return buildDefaultProductPlaceholder(
        width: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
        height: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
        fit: BoxFit.cover,
      );
    }

    final imageUrl = fixImageUrl(produit.image);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.primaryGreen,
        ),
      ),
      errorWidget: (context, url, error) {
        return buildDefaultProductPlaceholder(
          width: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
          height: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
