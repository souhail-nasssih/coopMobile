import 'package:flutter/material.dart';
import 'package:gestioncoop/providers/cart_provider.dart';
import 'package:gestioncoop/screens/cart/cart_page.dart';
import 'package:gestioncoop/screens/category/categories_page.dart';
import 'package:gestioncoop/screens/home/home_page.dart';
import 'package:gestioncoop/screens/cooperatives/cooperatives_page.dart';
import 'package:gestioncoop/screens/settings/settings_page.dart';
import 'package:gestioncoop/widgets/app/app_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NatureCoop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFFFF9800),
        ),
        useMaterial3: true,
      ),
      home: const MainWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CategoriesPage(),
    CooperativesPage(),
    SettingsPage(), // Retiré CartPage de la liste
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: CustomAppBar(
        cartItemCount: Provider.of<CartProvider>(context).items.length,
        onCartPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar:  _buildBottomNavBar(),
    );
  }



  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      backgroundColor: Colors.white,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: [
        _buildNavItem(Icons.home_outlined, Icons.home, 'Accueil', 0),
        _buildNavItem(Icons.category_outlined, Icons.category, 'Catégories', 1),
        _buildNavItem(Icons.people_outline, Icons.people, 'Coopératives', 2),
        _buildNavItem(Icons.settings_outlined, Icons.settings, 'Paramètres', 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(_currentIndex == index ? activeIcon : icon),
      activeIcon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(activeIcon, size: 26),
      ),
      label: label,
    );
  }
}