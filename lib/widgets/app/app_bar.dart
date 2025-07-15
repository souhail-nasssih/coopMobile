import 'package:flutter/material.dart';
import 'package:gestioncoop/services/AuthService.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final TextEditingController? searchController;
  final VoidCallback? onSearchSubmitted;
  final bool showBanner;
  final int
  cartItemCount; // Nouveau paramètre pour le nombre d'articles dans le panier
  final VoidCallback? onCartPressed; // Callback pour le clic sur l'icône panier

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.searchController,
    this.onSearchSubmitted,
    this.showBanner = true,
    this.cartItemCount = 0, // Par défaut à 0
    this.onCartPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight +
        (showBanner ? 32 : 0) +
        (searchController != null ? 72 : 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      surfaceTintColor: Colors.white,
      toolbarHeight: preferredSize.height,
      leading: leading,
      titleSpacing: 0,
      flexibleSpace: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: preferredSize.height,
                  maxWidth: constraints.maxWidth,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showBanner) _buildTopBanner(),
                    _buildMainAppBar(context),
                    if (searchController != null) _buildSearchField(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4CAF50), // Vert - première couleur que vous avez demandée
            Color(
              0xFFFF9800,
            ), // Orange - deuxième couleur que vous avez demandée
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.eco, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'COMMERCE ÉQUITABLE - PRODUITS 100% NATURELS - Soutien aux coopératives locales',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.agriculture, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildMainAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: BoxConstraints(
        maxHeight: kToolbarHeight,
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showLogo) Flexible(fit: FlexFit.loose, child: _buildLogo()),
          if (title != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          _buildCartIcon(),

          // ✅ Remplacement par ton widget fonctionnel :
          const GoogleAuthButton(),

          if (actions != null)
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      actions!
                          .map(
                            (action) => Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: action,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Naviguer vers la page d'accueil
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_basket,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nature',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D32),
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Coop',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF9800),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(28),
        shadowColor: Colors.black.withOpacity(0.1),
        child: TextField(
          controller: searchController,
          onSubmitted: (_) => onSearchSubmitted?.call(),
          decoration: InputDecoration(
            hintText: 'Rechercher des produits...',
            hintStyle: const TextStyle(color: Color(0xFF757575)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF757575)),
            suffixIcon:
                searchController?.text.isNotEmpty == true
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF757575)),
                      onPressed: () {
                        searchController?.clear();
                      },
                    )
                    : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Badge(
        label: cartItemCount > 0 ? Text(cartItemCount.toString()) : null,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        largeSize: 18,
        child: IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          color: const Color(0xFF2E7D32),
          onPressed: onCartPressed,
          tooltip: 'Panier',
        ),
      ),
    );
  }
}




class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({Key? key}) : super(key: key);

  @override
  _GoogleAuthButtonState createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  final AuthService _authService = AuthService();
  bool _loading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    setState(() => _loading = true);
    final token = await _authService.getAuthToken();
    setState(() {
      _isLoggedIn = token != null;
      _loading = false;
    });
  }

  Future<void> _handleAuthAction() async {
    setState(() => _loading = true);
    try {
      if (_isLoggedIn) {
        await _authService.signOut();
        setState(() => _isLoggedIn = false);
      } else {
        final success = await _authService.signInWithGoogle();
        if (success) {
          setState(() => _isLoggedIn = true);
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : _isLoggedIn
            ? IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _handleAuthAction,
              )
            : OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Connexion Google'),
                onPressed: _handleAuthAction,
              );
  }
}