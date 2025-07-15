import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gestioncoop/models/Coop.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/models/Review.dart';
import 'package:gestioncoop/screens/home/product_detail_page.dart';
import 'package:gestioncoop/widgets/products/product_grid.dart';

class CoopDetailPage extends StatefulWidget {
  final Coop coop;
  final List<Produit> produits;
  final List<Review> reviews; // Si vous avez une liste d'avis à afficher

  const CoopDetailPage({
    super.key,
    required this.coop,
    required this.produits,
    required this.reviews,
  });

  @override
  State<CoopDetailPage> createState() => _CoopDetailPageState();
}

class _CoopDetailPageState extends State<CoopDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      body: Column(
        children: [
          // Section fixe en haut (cover + profile)
          _buildHeaderSection(context, primaryColor, secondaryColor),

          // Barre d'onglets
          _buildTabBar(primaryColor, secondaryColor),

          // Contenu coulissant horizontal
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Onglet 1: Produits
                ProductGrid(
                  futureProduits: Future.value(widget.produits),
                  crossAxisCount: 2,
                  shrinkWrap: false,
                  onProductTap: (produit) {
                    _navigateToProductDetail(context, produit);
                  },
                ),

                // Onglet 2: Informations
                _buildInfoTab(context, primaryColor),

                // Onglet 3: Avis
                _buildReviewsTab(primaryColor, secondaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    Color primaryColor,
    Color secondaryColor,
  ) {
    // Debug: Affichez les URLs pour vérification
    debugPrint('Cover URL: ${widget.coop.coverUrl}');
    debugPrint('Profile URL: ${widget.coop.profileUrl}');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Image de couverture
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.8),
                primaryColor.withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _buildNetworkImage(
            url: widget.coop.coverUrl,
            placeholder: Icon(
              Icons.photo_library,
              size: 50,
              color: Colors.white70,
            ),
            errorWidget: Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.white70,
            ),
            blendColor: primaryColor.withOpacity(0.3),
          ),
        ),

        // Bouton retour
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.8),
            radius: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        // Photo de profil
        Positioned(
          bottom: -40,
          left: 20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildNetworkImage(
                url: widget.coop.profileUrl,
                placeholder: Icon(Icons.store, size: 40, color: primaryColor),
                errorWidget: Icon(Icons.store, size: 40, color: primaryColor),
                isProfile: true,
              ),
            ),
          ),
        ),

        // Nom et note
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.coop.nom,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      widget.coop.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImage({
    required String url,
    required Widget placeholder,
    required Widget errorWidget,
    Color? blendColor,
    bool isProfile = false,
  }) {
    if (url.isEmpty) return placeholder;

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      color: blendColor,
      colorBlendMode: blendColor != null ? BlendMode.overlay : null,
      placeholder:
          (context, url) => Center(
            child: SizedBox(
              width: isProfile ? 20 : 40,
              height: isProfile ? 20 : 40,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      errorWidget: (context, url, error) {
        debugPrint('Image load error: $error - URL: $url');
        return Center(child: errorWidget);
      },
    );
  }

  Widget _buildTabBar(Color primaryColor, Color secondaryColor) {
    return Container(
      margin: const EdgeInsets.only(top: 50, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabButton(0, 'Produits', primaryColor, secondaryColor),
          _buildTabButton(1, 'Informations', primaryColor, secondaryColor),
          _buildTabButton(2, 'Avis', primaryColor, secondaryColor),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    int index,
    String text,
    Color primaryColor,
    Color secondaryColor,
  ) {
    final isSelected = _currentPage == index;

    return InkWell(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected ? Border.all(color: primaryColor, width: 1.5) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section À propos
          Text(
            'À propos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200] ?? Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.coop.description,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  Icons.category,
                  'Domaine',
                  widget.coop.domaine,
                  primaryColor,
                ),
                if (widget.coop.anneeCreation != null)
                  _buildInfoItem(
                    Icons.calendar_today_outlined,
                    'Année de création',
                    widget.coop.anneeCreation!,
                    primaryColor,
                  ),
                if (widget.coop.certifications != null)
                  _buildInfoItem(
                    Icons.verified_outlined,
                    'Certifications',
                    widget.coop.certifications!,
                    primaryColor,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section Coordonnées
          Text(
            'Coordonnées',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.email_outlined,
            'Email',
            widget.coop.email,
            primaryColor,
          ),

        
          // Section Technique (ID, etc.)
          const SizedBox(height: 20),
          Text(
            'Point de vente principal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200] ?? Colors.grey),
            ),
            child: Column(
              children: [
                _buildInfoItem(
                  Icons.location_on,
                  'Adresse',
                  widget.coop.mainPointVent?.adresse ?? 'N/A',
                  primaryColor,
                ),
                _buildInfoItem(
                  Icons.phone,
                  'Téléphone',
                  widget.coop.mainPointVent?.telephone ?? 'N/A',
                  primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color primaryColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(Color primaryColor, Color secondaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.star, size: 50, color: secondaryColor),
                const SizedBox(height: 16),
                Text(
                  widget.coop.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sur ${widget.coop.reviewsCount} avis',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Action pour ajouter un avis
                    },
                    child: const Text(
                      'Laisser un avis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Section pour afficher les avis
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Derniers avis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                if (widget.reviews.isEmpty)
                  Center(
                    child: Text(
                      'Aucun avis pour le moment',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                if (widget.reviews.isNotEmpty)
                  Column(
                    children:
                        widget.reviews
                            .map((review) => _buildReviewItem(review))
                            .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: (review.avatar?.isNotEmpty == true)
                    ? NetworkImage(review.avatar!)
                    : null,
                radius: 20,
                child: (review.avatar?.isNotEmpty != true)
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.author ?? 'Anonyme',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(review.rating != null ? review.rating!.toStringAsFixed(1) : '-'),
                      const SizedBox(width: 8),
                      Text(review.date ?? ''),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment ?? '', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Produit produit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(produit: produit),
      ),
    );
  }
}
