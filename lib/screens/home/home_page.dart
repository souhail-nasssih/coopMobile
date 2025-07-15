import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/home/product_detail_page.dart';
import 'package:gestioncoop/services/produit_service.dart';
import 'package:gestioncoop/widgets/products/product_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProduitService _produitService = ProduitService();
  late Future<List<Produit>> _futureProduits;
  // final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProduits = _produitService.fetchProduits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: Column(
        children: [
          // const HeroBanner(
          //   title: 'SOUTENEZ LES COOPÉRATIVES',
          //   subtitle: '100% des bénéfices reviennent aux producteurs',
          //   buttonText: 'Découvrir les coopératives',
          //   statsText: '+80% revenu',
          // ),
          // Solution clé : Expanded pour donner une hauteur contrainte
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureProduits = _produitService.fetchProduits();
                });
              },
              child: ProductGrid(
                futureProduits: _futureProduits,
                onProductTap: (produit) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(produit: produit),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
