import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gestioncoop/models/Coop.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/models/Review.dart';
import 'package:gestioncoop/screens/cooperatives/coop_detail_page.dart';
import 'package:gestioncoop/services/coop_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coopératives'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCoops,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: FutureBuilder<List<Coop>>(
        future: _futureCoops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshCoops,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune coopérative disponible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenez plus tard ou actualisez la page',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final coops = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: coops.length,
            itemBuilder: (context, index) {
              return CoopCard(
                coop: coops[index],
                onTap: () {
                  // Navigation vers la page de détail
                  _navigateToCoopDetail(coops[index]);
                },
              );
            },
          );
        },
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
          builder:
              (context) => CoopDetailPage(
                coop: coopComplet.copyWith(
                  profileUrl:
                      coop.profileUrl.isNotEmpty
                          ? coop.profileUrl
                          : coopComplet.profileUrl,
                  coverUrl:
                      coop.coverUrl.isNotEmpty
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }
}

class CoopCard extends StatelessWidget {
  final Coop coop;
  final VoidCallback? onTap;

  const CoopCard({required this.coop, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
              child:
                  coop.coverUrl.isNotEmpty
                      ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: coop.coverUrl,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Icon(
                                Icons.photo_library_outlined,
                                size: 40,
                                color: theme.disabledColor,
                              ),
                        ),
                      )
                      : Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 40,
                          color: theme.disabledColor,
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child:
                          coop.profileUrl.isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl: coop.profileUrl,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(
                                      Icons.people_outline,
                                      size: 30,
                                      color: theme.disabledColor,
                                    ),
                              )
                              : Icon(
                                Icons.people_outline,
                                size: 30,
                                color: theme.disabledColor,
                              ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and Domain
                        Text(
                          coop.nom,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          coop.domaine,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rating and Reviews
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              coop.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${coop.reviewsCount} avis)',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Additional Info
                        if (coop.anneeCreation != null) ...[
                          _buildInfoRow(
                            Icons.calendar_today_outlined,
                            'Depuis ${coop.anneeCreation}',
                            theme,
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (coop.certifications != null &&
                            coop.certifications!.isNotEmpty) ...[
                          _buildInfoRow(
                            Icons.verified_outlined,
                            coop.certifications!,
                            theme,
                          ),
                          const SizedBox(height: 4),
                        ],
                        _buildInfoRow(
                          Icons.email_outlined,
                          coop.email,
                          theme,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    ThemeData theme, {
    int maxLines = 2,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.disabledColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
