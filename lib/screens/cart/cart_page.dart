// ali_express_cart_page.dart
import 'package:flutter/material.dart';
import 'package:gestioncoop/screens/cart/CartItem.dart';
import 'package:provider/provider.dart';
import 'package:gestioncoop/providers/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final freeShippingThreshold = 100.0;
    final remainingForFreeShipping =
        freeShippingThreshold - cartProvider.totalPrice;
    final hasFreeShipping =
        cartProvider.items.any((item) => item.produit.isFreeShipping) ||
        cartProvider.totalPrice >= freeShippingThreshold;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Panier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearCartDialog(context, cartProvider),
            ),
        ],
      ),
      body: _buildBody(
        context,
        cartProvider,
        theme,
        hasFreeShipping,
        remainingForFreeShipping,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CartProvider cartProvider,
    ThemeData theme,
    bool hasFreeShipping,
    double remainingForFreeShipping,
  ) {
    const double freeShippingThreshold = 100.0;
    if (cartProvider.items.isEmpty) {
      return _buildEmptyCart(context, theme);
    }

    return Column(
      children: [
        // Bannière promotionnelle
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.orange[50],
          child: Row(
            children: [
              Icon(Icons.local_offer, color: Colors.orange[700], size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasFreeShipping
                      ? 'Vous bénéficiez de la livraison gratuite !'
                      : 'Plus que ${remainingForFreeShipping.toStringAsFixed(2)}€ pour la livraison gratuite',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Barre de progression
        if (!hasFreeShipping)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: cartProvider.totalPrice / freeShippingThreshold,
                  backgroundColor: Colors.grey[200],
                  color: Colors.orange,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  '${cartProvider.totalPrice.toStringAsFixed(2)}€ / ${freeShippingThreshold.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

        // Liste des produits
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: cartProvider.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = cartProvider.items[index];
              return _buildCartItem(context, item, cartProvider);
            },
          ),
        ),

        // Résumé et bouton de commande
        _buildCheckoutSummary(context, cartProvider, hasFreeShipping),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 20),
          Text(
            'Votre panier est vide',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Parcourez nos produits et ajoutez-les à votre panier',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartProvider cartProvider,
  ) {
    final produit = item.produit;
    final hasDiscount =
        produit.originalPrice != null && produit.originalPrice! > produit.prix;

    return Dismissible(
      key: Key(produit.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        cartProvider.removeFromCart(produit);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produit.libelle} retiré du panier'),
            action: SnackBarAction(
              label: 'Annuler',
              onPressed: () => cartProvider.addToCart(produit),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Theme.of(context).primaryColor,
            ),

            // Image du produit
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: produit.image,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Détails du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produit.libelle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Prix et promotion
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount)
                        Text(
                          '${produit.originalPrice!.toStringAsFixed(2)} DHS',
                          style: const TextStyle(
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      Row(
                        children: [
                          Text(
                            '${produit.prix.toStringAsFixed(2)} DHS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: hasDiscount ? Colors.red : Colors.black,
                            ),
                          ),
                          if (hasDiscount)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${((produit.originalPrice! - produit.prix) / produit.originalPrice! * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Badges
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (produit.isFreeShipping)
                        _buildBadge(
                          'Livraison gratuite',
                          Icons.local_shipping,
                          Colors.green,
                        ),
                      if (produit.isBio)
                        _buildBadge('Bio', Icons.eco, Colors.green),
                      if (produit.isEco)
                        _buildBadge('Éco', Icons.recycling, Colors.blue),
                    ],
                  ),
                ],
              ),
            ),

            // Contrôle quantité
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => cartProvider.removeFromCart(produit),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed:
                            () => cartProvider.decrementQuantity(produit.id),
                      ),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed:
                            () => cartProvider.incrementQuantity(produit.id),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${produit.qteStock}',
                  style: TextStyle(
                    fontSize: 12,
                    color: produit.qteStock > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
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
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Résumé des prix
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sous-total', style: TextStyle(fontSize: 15)),
              Text(
                '${cartProvider.totalPrice.toStringAsFixed(2)} DHS',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Livraison', style: TextStyle(fontSize: 15)),
              Text(
                hasFreeShipping ? 'Gratuite' : 'À calculer',
                style: TextStyle(
                  fontSize: 15,
                  color: hasFreeShipping ? Colors.green : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${cartProvider.totalPrice.toStringAsFixed(2)} DHS',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bouton de commande
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Couleur du texte
                backgroundColor: Colors.transparent, // Fond transparent
                shadowColor: Colors.transparent, // Pas d'ombre
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    EdgeInsets
                        .zero, // Important pour que le dégradé remplisse tout le bouton
              ),
              onPressed: () => _showOrderConfirmation(context, cartProvider),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4CAF50), // Vert
                      Color(0xFFFF9800), // Orange
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Passer la commande',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texte en blanc
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Vider le panier'),
            content: const Text(
              'Êtes-vous sûr de vouloir vider votre panier ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  cartProvider.clearCart();
                  Navigator.pop(context);
                },
                child: const Text('Vider', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showOrderConfirmation(BuildContext context, CartProvider cartProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text(
                  'Commande confirmée !',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      cartProvider.clearCart();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text(
                      'Retour à l\'accueil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
