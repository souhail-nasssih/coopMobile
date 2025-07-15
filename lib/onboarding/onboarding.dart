// onboarding_page.dart
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  final VoidCallback onFinish;
  
  const OnboardingPage({Key? key, required this.onFinish}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Bienvenue sur NatureCoop',
      description: 'Découvrez des produits naturels et équitables',
      image: 'assets/onboarding1.png', // Remplacez par vos assets
      color: Color(0xFF4CAF50),
    ),
    OnboardingItem(
      title: 'Soutenez les coopératives locales',
      description: 'Achetez directement auprès des producteurs',
      image: 'assets/onboarding2.png',
      color: Color(0xFFFF9800),
    ),
    OnboardingItem(
      title: 'Livraison rapide',
      description: 'Recevez vos produits frais en 24-48h',
      image: 'assets/onboarding3.png',
      color: Color(0xFF2E7D32),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingScreen(
                item: _pages[index],
                isLastPage: index == _pages.length - 1,
                onNext: _goToNextPage,
                onFinish: widget.onFinish,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i 
                ? _pages[i].color 
                : _pages[i].color.withOpacity(0.4),
          ),
        ),
      );
    }
    return indicators;
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      widget.onFinish();
    }
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

class OnboardingScreen extends StatelessWidget {
  final OnboardingItem item;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const OnboardingScreen({
    Key? key,
    required this.item,
    required this.isLastPage,
    required this.onNext,
    required this.onFinish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.color.withOpacity(0.1),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.image,
            height: 250,
          ),
          SizedBox(height: 40),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: item.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: item.color,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: isLastPage ? onFinish : onNext,
            child: Text(
              isLastPage ? 'Commencer' : 'Suivant',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}