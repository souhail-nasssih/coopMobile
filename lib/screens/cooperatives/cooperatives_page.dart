import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gestioncoop/models/Coop.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/models/Review.dart';
import 'package:gestioncoop/screens/cooperatives/coop_detail_page.dart';
import 'package:gestioncoop/services/coop_service.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';

class CooperativesPage extends StatefulWidget {
  const CooperativesPage({super.key});

  @override
  State<CooperativesPage> createState() => _CooperativesPageState();
}

class _CooperativesPageState extends State<CooperativesPage> {
  final CoopService _coopService = CoopService();
  late Future<List<Coop>> _futureCoops;

  @override
  void initState() {
    super.initState();
    _futureCoops = _coopService.fetchCoops();
  }

  void _refreshCoops() {
    setState(() {
      _futureCoops = _coopService.fetchCoops();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: FutureBuilder<List<Coop>>(
        future: _futureCoops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                  ),
                  SizedBox(height: responsive.spacing(mobile: 16, tablet: 20)),
                  Text(
                    'Chargement des coopératives...',
                    style: TextStyle(
                      fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, responsive, snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context, responsive);
          }

          final coops = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(responsive.spacing(mobile: 12, tablet: 16)),
            itemCount: coops.length,
            separatorBuilder: (context, index) => SizedBox(
              height: responsive.spacing(mobile: 8, tablet: 12),
            ),
            itemBuilder: (context, index) {
              return CoopCard(
                coop: coops[index],
                onTap: () => _navigateToCoopDetail(coops[index]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Responsive responsive, String error) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(responsive.spacing(mobile: 24, tablet: 32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(responsive.adaptive(mobile: 24, tablet: 32)),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: responsive.adaptive(mobile: 64, tablet: 80),
                color: AppTheme.errorColor,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 24, tablet: 32)),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: responsive.fontSize(mobile: 22, tablet: 26),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.spacing(mobile: 32, tablet: 48),
              ),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
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
                  onTap: _refreshCoops,
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
                        const Icon(Icons.refresh_rounded, color: Colors.white),
                        SizedBox(width: responsive.spacing(mobile: 8, tablet: 12)),
                        Text(
                          'Réessayer',
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

  Widget _buildEmptyState(BuildContext context, Responsive responsive) {
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
                Icons.people_outline_rounded,
                size: responsive.adaptive(mobile: 80, tablet: 100),
                color: AppTheme.primaryGreen,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 24, tablet: 32)),
            Text(
              'Aucune coopérative disponible',
              style: TextStyle(
                fontSize: responsive.fontSize(mobile: 24, tablet: 28, desktop: 32),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 12, tablet: 16)),
            Text(
              'Revenez plus tard ou actualisez la page',
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
                  onTap: _refreshCoops,
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
                        const Icon(Icons.refresh_rounded, color: Colors.white),
                        SizedBox(width: responsive.spacing(mobile: 8, tablet: 12)),
                        Text(
                          'Actualiser',
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

  void _navigateToCoopDetail(Coop coop) async {
    try {
      final data = await _coopService.fetchCoopProfile(coop.id);
      final produits = data['produits'] as List<Produit>;
      final coopComplet = data['coop'] as Coop;
      final reviews = data['reviews'] as List<Review>;

      print('Rating calculé: ${coopComplet.effectiveRating}');
      print('Nombre de reviews: ${reviews.length}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoopDetailPage(
            coop: coopComplet.copyWith(
              profileUrl: coop.profileUrl.isNotEmpty
                  ? coop.profileUrl
                  : coopComplet.profileUrl,
              coverUrl: coop.coverUrl.isNotEmpty
                  ? coop.coverUrl
                  : coopComplet.coverUrl,
            ),
            produits: produits,
            reviews: reviews,
          ),
        ),
      );
    } catch (e) {
      print('Erreur navigation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}

class CoopCard extends StatelessWidget {
  final Coop coop;
  final VoidCallback? onTap;

  const CoopCard({required this.coop, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final rating = coop.effectiveRating;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(
          responsive.adaptive(mobile: 20, tablet: 24),
        ),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            responsive.adaptive(mobile: 20, tablet: 24),
          ),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover Image avec overlay
              Stack(
                children: [
                  Container(
                    height: responsive.adaptive(mobile: 100, tablet: 120, desktop: 140),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          responsive.adaptive(mobile: 20, tablet: 24),
                        ),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: coop.coverUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                responsive.adaptive(mobile: 20, tablet: 24),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: coop.coverUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.photo_library_outlined,
                                    size: responsive.adaptive(mobile: 48, tablet: 60),
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.photo_library_outlined,
                                size: responsive.adaptive(mobile: 48, tablet: 60),
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            responsive.adaptive(mobile: 20, tablet: 24),
                          ),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge de rating en haut à droite
                  Positioned(
                    top: responsive.spacing(mobile: 12, tablet: 16),
                    right: responsive.spacing(mobile: 12, tablet: 16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.adaptive(mobile: 10, tablet: 12),
                        vertical: responsive.adaptive(mobile: 6, tablet: 8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(
                          responsive.adaptive(mobile: 12, tablet: 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: responsive.adaptive(mobile: 16, tablet: 18),
                          ),
                          SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Contenu de la carte
              Padding(
                padding: EdgeInsets.all(responsive.spacing(mobile: 12, tablet: 16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Container(
                      width: responsive.adaptive(mobile: 50, tablet: 60, desktop: 70),
                      height: responsive.adaptive(mobile: 50, tablet: 60, desktop: 70),
                      margin: EdgeInsets.only(
                        right: responsive.spacing(mobile: 12, tablet: 16),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryGreen.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: coop.profileUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: coop.profileUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.people_rounded,
                                    size: responsive.adaptive(mobile: 35, tablet: 40),
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.people_rounded,
                                  size: responsive.adaptive(mobile: 35, tablet: 40),
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                      ),
                    ),

                    // Informations
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nom
                          Text(
                            coop.nom,
                            style: TextStyle(
                              fontSize: responsive.fontSize(mobile: 16, tablet: 18),
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: responsive.spacing(mobile: 4, tablet: 6)),
                          
                          // Domaine
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.adaptive(mobile: 6, tablet: 8),
                              vertical: responsive.adaptive(mobile: 3, tablet: 4),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryOrange.withOpacity(0.15),
                                  AppTheme.primaryOrange.withOpacity(0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                responsive.adaptive(mobile: 8, tablet: 10),
                              ),
                              border: Border.all(
                                color: AppTheme.primaryOrange.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              coop.domaine,
                              style: TextStyle(
                                fontSize: responsive.fontSize(mobile: 12, tablet: 14),
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryOrange,
                              ),
                            ),
                          ),
                          SizedBox(height: responsive.spacing(mobile: 6, tablet: 8)),

                          // Reviews count
                          Row(
                            children: [
                              Icon(
                                Icons.reviews_rounded,
                                size: responsive.adaptive(mobile: 14, tablet: 16),
                                color: AppTheme.textSecondary,
                              ),
                              SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
                              Text(
                                '${coop.reviewsCount} avis',
                                style: TextStyle(
                                  fontSize: responsive.fontSize(mobile: 12, tablet: 13),
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.spacing(mobile: 6, tablet: 8)),

                          // Informations supplémentaires
                          if (coop.anneeCreation != null) ...[
                            _buildInfoRow(
                              Icons.calendar_today_rounded,
                              'Depuis ${coop.anneeCreation}',
                              responsive,
                            ),
                            SizedBox(height: responsive.spacing(mobile: 4, tablet: 6)),
                          ],
                          if (coop.certifications != null &&
                              coop.certifications!.isNotEmpty) ...[
                            _buildInfoRow(
                              Icons.verified_rounded,
                              coop.certifications!,
                              responsive,
                            ),
                            SizedBox(height: responsive.spacing(mobile: 4, tablet: 6)),
                          ],
                          _buildInfoRow(
                            Icons.email_rounded,
                            coop.email,
                            responsive,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Footer avec bouton
              Container(
                padding: EdgeInsets.fromLTRB(
                  responsive.spacing(mobile: 12, tablet: 16),
                  0,
                  responsive.spacing(mobile: 12, tablet: 16),
                  responsive.spacing(mobile: 12, tablet: 16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: responsive.adaptive(mobile: 40, tablet: 44),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(
                            responsive.adaptive(mobile: 12, tablet: 14),
                          ),
                          boxShadow: AppTheme.subtleShadow,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onTap,
                            borderRadius: BorderRadius.circular(
                              responsive.adaptive(mobile: 12, tablet: 14),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: responsive.spacing(mobile: 8, tablet: 10)),
                                  Text(
                                    'Voir les détails',
                                    style: TextStyle(
                                      fontSize: responsive.fontSize(mobile: 14, tablet: 16),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    Responsive responsive, {
    int maxLines = 2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: responsive.adaptive(mobile: 14, tablet: 16),
            color: AppTheme.primaryGreen,
          ),
        ),
        SizedBox(width: responsive.spacing(mobile: 8, tablet: 10)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: responsive.fontSize(mobile: 12, tablet: 14),
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
