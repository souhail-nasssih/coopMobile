import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSmall;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isSmall = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSmall ? null : double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF4A9B3E),
          foregroundColor: textColor ?? Colors.white,
          padding: isSmall 
              ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmall ? 6 : 8),
          ),
        ),
        child: icon != null 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: isSmall ? 14 : 20),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(fontSize: isSmall ? 12 : 16),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(fontSize: isSmall ? 12 : 16),
              ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSmall;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSmall ? null : double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4A9B3E),
          side: const BorderSide(color: Color(0xFF4A9B3E)),
          padding: isSmall 
              ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmall ? 6 : 8),
          ),
        ),
        child: icon != null 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: isSmall ? 14 : 20),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(fontSize: isSmall ? 12 : 16),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(fontSize: isSmall ? 12 : 16),
              ),
      ),
    );
  }
}