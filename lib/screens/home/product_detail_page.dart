import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/widgets/common/badges.dart';
import 'package:gestioncoop/widgets/common/buttons.dart';
import 'package:gestioncoop/models/Review.dart';

class ProductDetailPage extends StatelessWidget {
  final Produit produit;

  const ProductDetailPage({super.key, required this.produit});

  // Exemple de produit mock pour test visuel
  static Produit get mockProduit => Produit(
    id: 1,
    libelle: 'Tomates Bio',
    description: 'Tomates biologiques fraîches du jardin',
    prix: 3.5,
    originalPrice: null,
    image: 'http://10.0.2.2:8000/storage/produits/WHi8YM1gqeZ3oi3qugVEcL3JS5fmiLrw1QIgqqWv.png',
    qteStock: 100,
    isBio: true,
    isEco: true,
    fairTrade: false,
    isFreeShipping: true,
    soldCount: 0,
    rating: 2,
    reviewsCount: 1,
    averageRating: 2,
    totalReviews: 1,
    category: null,
    cooperative: null,
    pointVentId: null,
    reviews: [
      Review(
        id: 1,
        userId: 5,
        author: 'Jean Dupont',
        rating: 2,
        comment: 'Pas assez mûres.',
        date: '2024-06-01',
        avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
        productName: 'Tomates Bio',
      ),
      Review(
        id: 2,
        userId: 6,
        author: 'Sophie Martin',
        rating: 4,
        comment: 'Très bon goût, je recommande !',
        date: '2024-06-02',
        avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
        productName: 'Tomates Bio',
      ),
    ],
  );

  String getFixedImageUrl(String url) {
    if (url.isEmpty) return '';
    if (url.startsWith('/storage')) {
      return 'http://192.168.1.10:8000$url'; // 🔹 Remplace par ton IP locale
    }
    if (url.contains('127.0.0.1')) {
      return url.replaceFirst('127.0.0.1', '192.168.1.10'); // 🔹 Remplace ici aussi
    }
    return url;
  }

  Widget buildProductImage(String? image) {
    final imageUrl = getFixedImageUrl(image ?? '');
    final isValidImageUrl = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    print('imageUrl utilisé: $imageUrl');
    if (isValidImageUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey, size: 80),
      );
    } else {
      return const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 80),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Nombre de reviews pour ce produit : \\${produit.reviews.length} (totalReviews: \\${produit.totalReviews})');
    if (produit.reviews.isEmpty && produit.totalReviews > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attention : Les avis ne sont pas chargés alors que totalReviews > 0. Vérifiez le parsing JSON !')),
        );
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212529)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF212529)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF212529)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image produit
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[100],
              child: buildProductImage(produit.image),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          produit.libelle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212529),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${produit.prix.toStringAsFixed(2)} DHS',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                          if (produit.originalPrice != null)
                            Text(
                              '${produit.originalPrice!.toStringAsFixed(2)} DHS',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6C757D),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (produit.isBio) const EcoBadge(),
                      if (produit.fairTrade) const FairTradeBadge(),
                      if (produit.isFreeShipping) const FreeShippingBadge(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Note et avis amélioré
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Affichage dynamique des étoiles
                      Row(
                        children: List.generate(5, (index) {
                          final filled = index < produit.averageRating.round();
                          return Icon(
                            filled ? Icons.star : Icons.star_border,
                            color: Color(0xFFFFC107),
                            size: 22,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        produit.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212529),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${produit.totalReviews} avis)',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${produit.soldCount} vendus',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        // Action à définir pour afficher les avis détaillés
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Affichage des avis à venir...')),
                        );
                      },
                      icon: const Icon(Icons.reviews, color: Color(0xFF4A9B3E)),
                      label: const Text(
                        'Voir tous les avis',
                        style: TextStyle(color: Color(0xFF4A9B3E)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produit.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF495057),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section affichage des commentaires/avis
                  const SizedBox(height: 16),
                  Text(
                    'Avis des utilisateurs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (produit.reviews.isEmpty)
                    const Text('Aucun avis pour ce produit.', style: TextStyle(color: Color(0xFF6C757D))),
                  ...produit.reviews.map((review) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: (review.avatar?.isNotEmpty == true)
                          ? CircleAvatar(backgroundImage: NetworkImage(review.avatar!))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Row(
                        children: [
                          Text(review.author ?? 'Anonyme', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          ...List.generate(5, (i) => Icon(
                            (review.rating != null ? i < review.rating!.round() : false)
                                ? Icons.star
                                : Icons.star_border,
                            color: Color(0xFFFFC107), size: 16,
                          )),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.comment ?? ''),
                          const SizedBox(height: 4),
                          Text(
                            review.date ?? '',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),

                  const SizedBox(height: 24),

                  // Bouton ajouter au panier
                  PrimaryButton(
                    text: 'AJOUTER AU PANIER',
                    icon: Icons.shopping_cart,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${produit.libelle} ajouté au panier'),
                          backgroundColor: const Color(0xFF4A9B3E),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
