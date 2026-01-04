import 'package:flutter/material.dart';
import 'package:gestioncoop/services/AuthService.dart';
import 'package:gestioncoop/theme/app_theme.dart';
import 'package:gestioncoop/helpers/responsive.dart';
import 'package:gestioncoop/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final TextEditingController? searchController;
  final VoidCallback? onSearchSubmitted;
  final bool showBanner;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.searchController,
    this.onSearchSubmitted,
    this.showBanner = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight +
        (showBanner ? 40 : 0) +
        (searchController != null ? 72 : 0),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundWhite,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: preferredSize.height,
      leading: leading,
      titleSpacing: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundWhite,
              AppTheme.backgroundWhite.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showBanner) _buildTopBanner(),
                      _buildMainAppBar(context),
                      if (searchController != null) _buildSearchField(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF66BB6A),
            Color(0xFFFF9800),
            Color(0xFFFF6B35),
          ],
          stops: [0.0, 0.4, 0.6, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'COMMERCE ÉQUITABLE • 100% NATURELS • SOUTIEN LOCAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMainAppBar(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.only(
        left: responsive.adaptive(mobile: 12, tablet: 16, desktop: 20),
        right: responsive.adaptive(mobile: 12, tablet: 16, desktop: 20),
        top: responsive.adaptive(mobile: 6, tablet: 8, desktop: 10),
        bottom: responsive.adaptive(mobile: 6, tablet: 8, desktop: 10),
      ),
      constraints: BoxConstraints(
        minHeight: kToolbarHeight - (showBanner ? 40 : 0),
        maxHeight: kToolbarHeight,
        minWidth: MediaQuery.of(context).size.width,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo avec nom de l'application - toujours visible
          if (showLogo)
            Expanded(
              flex: title != null ? 2 : 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildLogo(context),
              ),
            ),

          // Titre de la page (si présent)
          if (title != null) ...[
            SizedBox(width: responsive.spacing(mobile: 8, tablet: 12)),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: responsive.fontSize(mobile: 18, tablet: 20, desktop: 22),
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryGreenDark,
                    letterSpacing: -0.5,
                    shadows: [
                      Shadow(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],

          // Actions à droite : Connexion, autres actions
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: responsive.spacing(mobile: 4, tablet: 8)),
                const GoogleAuthButton(),
                if (actions != null) ...[
                  SizedBox(width: responsive.spacing(mobile: 4, tablet: 8)),
                  ...actions!.map(
                    (action) => Padding(
                      padding: EdgeInsets.only(
                        left: responsive.spacing(mobile: 4, tablet: 6),
                      ),
                      child: action,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final responsive = Responsive(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Naviguer vers la page d'accueil
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo avec gradient moderne et effet 3D
            Container(
              padding: EdgeInsets.all(
                responsive.adaptive(mobile: 8, tablet: 10, desktop: 12),
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF66BB6A),
                    Color(0xFF2E7D32),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                  responsive.adaptive(mobile: 16, tablet: 18, desktop: 20),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_basket_rounded,
                color: Colors.white,
                size: responsive.adaptive(mobile: 26, tablet: 28, desktop: 30),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(width: responsive.spacing(mobile: 10, tablet: 12)),
            // Nom de l'application avec design moderne
            Flexible(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nature',
                      style: TextStyle(
                        fontSize: responsive.fontSize(mobile: 22, tablet: 24, desktop: 26),
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGreenDark,
                        letterSpacing: -1.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: 'Coop',
                      style: TextStyle(
                        fontSize: responsive.fontSize(mobile: 22, tablet: 24, desktop: 26),
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryOrange,
                        letterSpacing: -1.0,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryOrange.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
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

  Widget _buildSearchField(BuildContext context) {
    final responsive = Responsive(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.adaptive(mobile: 16, tablet: 20, desktop: 24),
        0,
        responsive.adaptive(mobile: 16, tablet: 20, desktop: 24),
        responsive.adaptive(mobile: 12, tablet: 14, desktop: 16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            responsive.adaptive(mobile: 28, tablet: 32, desktop: 36),
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: TextField(
          controller: searchController,
          onSubmitted: (_) => onSearchSubmitted?.call(),
          style: TextStyle(
            fontSize: responsive.fontSize(mobile: 14, tablet: 15, desktop: 16),
          ),
          decoration: InputDecoration(
            hintText: 'Rechercher des produits...',
            hintStyle: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: responsive.fontSize(mobile: 14, tablet: 15),
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            suffixIcon: searchController?.text.isNotEmpty == true
                ? IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                    ),
                    onPressed: () {
                      searchController?.clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: AppTheme.backgroundWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                responsive.adaptive(mobile: 28, tablet: 32, desktop: 36),
              ),
              borderSide: BorderSide(
                color: AppTheme.primaryGreen.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                responsive.adaptive(mobile: 28, tablet: 32, desktop: 36),
              ),
              borderSide: BorderSide(
                color: AppTheme.primaryGreen.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                responsive.adaptive(mobile: 28, tablet: 32, desktop: 36),
              ),
              borderSide: BorderSide(
                color: AppTheme.primaryGreen,
                width: 2.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.adaptive(mobile: 20, tablet: 24, desktop: 28),
              vertical: responsive.adaptive(mobile: 14, tablet: 16, desktop: 18),
            ),
          ),
        ),
      ),
    );
  }

}




// class GoogleAuthButton extends StatefulWidget {
//   const GoogleAuthButton({Key? key}) : super(key: key);

//   @override
//   _GoogleAuthButtonState createState() => _GoogleAuthButtonState();
// }

// class _GoogleAuthButtonState extends State<GoogleAuthButton> {
//   final AuthService _authService = AuthService();
//   bool _loading = false;
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthStatus();
//   }

//   Future<void> _checkAuthStatus() async {
//     setState(() => _loading = true);
//     final token = await _authService.getAuthToken();
//     setState(() {
//       _isLoggedIn = token != null;
//       _loading = false;
//     });
//   }

//   Future<void> _handleAuthAction() async {
//     setState(() => _loading = true);
//     try {
//       if (_isLoggedIn) {
//         await _authService.signOut();
//         setState(() => _isLoggedIn = false);
//       } else {
//         final success = await _authService.signInWithGoogle();
//         if (success) {
//           setState(() => _isLoggedIn = true);
//           Navigator.pushReplacementNamed(context, '/');
//         }
//       }
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _loading
//         ? const CircularProgressIndicator()
//         : _isLoggedIn
//             ? IconButton(
//                 icon: const Icon(Icons.logout),
//                 onPressed: _handleAuthAction,
//               )
//             : OutlinedButton.icon(
//                 icon: const Icon(Icons.login),
//                 label: const Text('Conx Google'),
//                 onPressed: _handleAuthAction,
//               );
//   }
// }

class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({Key? key}) : super(key: key);

  @override
  _GoogleAuthButtonState createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  bool _loading = false;
  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _authService.isAuthenticated();
    final userData = await _authService.getUserData();
    if (mounted) {
      setState(() {
        _isLoggedIn = isAuth;
        _userData = userData;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final result = await _authService.signInWithGoogle();

      if (result != null && result['success'] == true) {
        if (mounted) {
          // Mettre à jour l'état de connexion
          await _checkAuthStatus();

          // Recharger le panier depuis le serveur
          try {
            final cartProvider = Provider.of<CartProvider>(context, listen: false);
            await cartProvider.reloadCart();
          } catch (e) {
            print('Erreur lors du rechargement du panier: $e');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connexion réussie ! Bonjour ${_userData?['name'] ?? 'Utilisateur'}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
      if (mounted) {
        final message = result?['message'] ?? 'Erreur de connexion';
        final helpUrl = result?['helpUrl'];

        // Afficher un dialog avec instructions si c'est une erreur de configuration
        if (result?['error'] == 'Erreur Google' && helpUrl != null) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
                title: const Text('Configuration requise'),
                content: SingleChildScrollView(
                  child: Text(message),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fermer'),
                  ),
                  if (helpUrl != null)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Optionnel : ouvrir l'URL dans le navigateur
                      },
                      child: const Text('Voir le guide'),
                    ),
                ],
              ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      }
    } catch (e) {
      debugPrint("Erreur connexion Google: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleSignOut() async {
    setState(() => _loading = true);
    try {
      await _authService.signOut();
      if (mounted) {
        await _checkAuthStatus();

        // Vider le panier local après déconnexion
        try {
          final cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.clearLocalCart();
        } catch (e) {
          print('Erreur lors du vidage du panier: $e');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Déconnexion réussie'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la déconnexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (_loading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    final responsive = Responsive(context);

    // Si l'utilisateur est connecté, afficher l'avatar ou le nom
    if (_isLoggedIn && _userData != null) {
      return PopupMenuButton<String>(
        tooltip: 'Utilisateur connecté',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.adaptive(mobile: 10, tablet: 12, desktop: 14),
            vertical: responsive.adaptive(mobile: 6, tablet: 8, desktop: 10),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.2),
                primaryColor.withOpacity(0.12),
                primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              responsive.adaptive(mobile: 24, tablet: 28, desktop: 32),
            ),
            border: Border.all(
              color: primaryColor.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar ou initiale avec bordure animée
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: _userData!['avatar'] != null && _userData!['avatar'].toString().isNotEmpty
                    ? CircleAvatar(
                        radius: responsive.adaptive(mobile: 16, tablet: 18, desktop: 20),
                        backgroundImage: NetworkImage(_userData!['avatar']),
                        backgroundColor: primaryColor.withOpacity(0.2),
                      )
                    : CircleAvatar(
                        radius: responsive.adaptive(mobile: 16, tablet: 18, desktop: 20),
                        backgroundColor: primaryColor,
                        child: Text(
                          _userData!['name']?.toString().substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.fontSize(mobile: 14, tablet: 16),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: responsive.spacing(mobile: 8, tablet: 10)),
              // Nom (tronqué si trop long)
              Flexible(
                child: Text(
                  _userData!['name']?.toString().split(' ').first ?? 'Utilisateur',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: responsive.fontSize(mobile: 14, tablet: 15, desktop: 16),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    shadows: [
                      Shadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: responsive.spacing(mobile: 4, tablet: 6)),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: primaryColor,
                size: responsive.adaptive(mobile: 20, tablet: 22, desktop: 24),
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData!['name'] ?? 'Utilisateur',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (_userData!['email'] != null)
                  Text(
                    _userData!['email'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Déconnexion', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'logout') {
            _handleSignOut();
          }
        },
      );
    }

    // Si non connecté, afficher le bouton de connexion moderne
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          responsive.adaptive(mobile: 14, tablet: 16, desktop: 18),
        ),
        border: Border.all(
          color: primaryColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(
            responsive.adaptive(mobile: 14, tablet: 16, desktop: 18),
          ),
          child: Container(
            padding: EdgeInsets.all(
              responsive.adaptive(mobile: 10, tablet: 12, desktop: 14),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: primaryColor,
              size: responsive.adaptive(mobile: 24, tablet: 26, desktop: 28),
            ),
          ),
        ),
      ),
    );
  }
}
