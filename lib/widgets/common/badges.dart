import 'package:flutter/material.dart';

class EcoBadge extends StatelessWidget {
  const EcoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF4A9B3E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'BIO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CoopBadge extends StatelessWidget {
  const CoopBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C00),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'COOP',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FairTradeBadge extends StatelessWidget {
  const FairTradeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C00),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'ÉQUITABLE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FreeShippingBadge extends StatelessWidget {
  const FreeShippingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'LIVRAISON GRATUITE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}