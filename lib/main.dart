import 'package:flutter/material.dart';
import 'package:gestioncoop/providers/cart_provider.dart';
import 'package:gestioncoop/screens/cart/cart_page.dart';
import 'package:gestioncoop/screens/category/categories_page.dart';
import 'package:gestioncoop/screens/home/home_page.dart';
import 'package:gestioncoop/screens/cooperatives/cooperatives_page.dart';
import 'package:gestioncoop/screens/settings/settings_page.dart';
import 'package:gestioncoop/widgets/app/app_bar.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';
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
      theme: AppTheme.lightTheme,
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
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 75,
        ),
        child: _buildCartFAB(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCartFAB() {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemCount = cartProvider.items.length;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final responsive = Responsive(context);
    final hasItems = cartItemCount > 0;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: responsive.adaptive(mobile: 68, tablet: 76, desktop: 84),
            height: responsive.adaptive(mobile: 68, tablet: 76, desktop: 84),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasItems
                    ? [
                        const Color(0xFFFF6B35), // Orange vif
                        const Color(0xFFFF8E53), // Orange clair
                        const Color(0xFFFF9800), // Orange principal
                        primaryColor, // Vert
                      ]
                    : [
                        primaryColor, // Vert principal
                        const Color(0xFF66BB6A), // Vert clair
                        const Color(0xFF4CAF50), // Vert moyen
                        const Color(0xFF2E7D32), // Vert foncé
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2.5,
              ),
              boxShadow: [
                // Ombre principale colorée
                BoxShadow(
                  color: (hasItems ? const Color(0xFFFF6B35) : primaryColor)
                      .withOpacity(0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                  spreadRadius: 3,
                ),
                // Ombre secondaire
                BoxShadow(
                  color: (hasItems ? const Color(0xFFFF9800) : primaryColor)
                      .withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
                // Ombre noire pour profondeur
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                customBorder: const CircleBorder(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Effet de brillance
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: responsive.adaptive(mobile: 20, tablet: 24, desktop: 28),
                        height: responsive.adaptive(mobile: 20, tablet: 24, desktop: 28),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Icône principale
                    Center(
                      child: Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                        size: responsive.adaptive(mobile: 30, tablet: 34, desktop: 38),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    // Badge animé
                    if (hasItems)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.bounceOut,
                          builder: (context, badgeValue, child) {
                            return Transform.scale(
                              scale: badgeValue,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: cartItemCount > 9 ? 7 : 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF1744), // Rouge vif
                                        Color(0xFFE53935), // Rouge moyen
                                        Color(0xFFC62828), // Rouge foncé
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.6),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 22,
                                    minHeight: 22,
                                  ),
                                  child: Center(
                                    child: Text(
                                      cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsive.fontSize(mobile: 12, tablet: 13),
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildBottomNavBar() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final responsive = Responsive(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: responsive.padding(
            mobile: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            tablet: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            desktop: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.home_outlined,
                Icons.home_rounded,
                'Accueil',
                0,
                primaryColor,
              ),
              _buildNavItem(
                Icons.category_outlined,
                Icons.category_rounded,
                'Catégories',
                1,
                primaryColor,
              ),
              _buildNavItem(
                Icons.people_outline,
                Icons.people_rounded,
                'Coopératives',
                2,
                primaryColor,
              ),
              _buildNavItem(
                Icons.settings_outlined,
                Icons.settings_rounded,
                'Paramètres',
                3,
                primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
    Color primaryColor,
  ) {
    final responsive = Responsive(context);
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: responsive.padding(
          mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          tablet: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          desktop: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.15),
                    primaryColor.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(
                isSelected 
                  ? responsive.adaptive(mobile: 5, tablet: 6, desktop: 7)
                  : 0
              ),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor.withOpacity(0.2) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? primaryColor : Colors.grey[600],
                size: isSelected 
                  ? responsive.adaptive(mobile: 24, tablet: 26, desktop: 28)
                  : responsive.adaptive(mobile: 22, tablet: 24, desktop: 26),
              ),
            ),
            SizedBox(height: responsive.spacing(mobile: 3, tablet: 4)),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: responsive.fontSize(mobile: 10, tablet: 11, desktop: 12),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? primaryColor : Colors.grey[600],
                  letterSpacing: 0.1,
                  height: 1.1,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}