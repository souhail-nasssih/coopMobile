import 'package:flutter/material.dart';
import 'package:gestioncoop/models/Produit.dart';
import 'package:gestioncoop/screens/home/product_detail_page.dart';
import 'package:gestioncoop/services/category_service.dart';
import 'package:gestioncoop/widgets/products/product_grid.dart'; // Utilisation de ProductGrid

class ProductByCategorie extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductByCategorie({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductByCategorie> createState() => _ProductByCategorieState();
}

class _ProductByCategorieState extends State<ProductByCategorie> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<Produit>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _futureProducts = _categoryService.fetchProduitsByCategory(widget.categoryId);
  }

  void _refreshProducts() {
    setState(() {
      _loadProducts();
    });
  }

void _onProductTap(Produit produit) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(produit: produit),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: ProductGrid(
        futureProduits: _futureProducts,
        onProductTap: _onProductTap,
        crossAxisCount: 2,
      ),
    );
  }
}
