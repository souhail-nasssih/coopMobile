// hero_banner.dart (extrait corrigé)
import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String statsText;

  const HeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.statsText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                // <<< Important ici pour éviter overflow
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statsText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: Text(buttonText)),
        ],
      ),
    );
  }
}
