import 'package:flutter/material.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/auth/login_screen.dart';

typedef NavigateToTabCallback = void Function(int tabIndex);

class AppSidebar extends StatelessWidget {
  final User user;
  final NavigateToTabCallback onNavigateToTab;

  const AppSidebar({
    super.key,
    required this.user,
    required this.onNavigateToTab,
  });

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 26, color: AppTheme.primaryLight),
            const SizedBox(width: 20),
            Text(
              title,
              style: AppTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.cardColor,
      elevation: 2.0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.dividerColor, width: 1),
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.textPrimary.withAlpha((0.05 * 255).round()),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: AppTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: AppTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: AppTheme.dividerColor.withAlpha((0.5 * 255).round()), height: 30),
              const SizedBox(height: 10),
              _buildDrawerItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Carteira',
                onTap: () {
                  Navigator.pop(context);
                  onNavigateToTab(1);
                },
              ),
              _buildDrawerItem(
                icon: Icons.person_outline,
                title: 'Perfil',
                onTap: () {
                  Navigator.pop(context);
                  onNavigateToTab(3);
                },
              ),
              _buildDrawerItem(
                icon: Icons.bar_chart_outlined,
                title: 'Estatísticas',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela de Estatísticas (a implementar)')),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.swap_horiz_outlined,
                title: 'Transferências',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela de Transferências (a implementar)')),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.settings_outlined,
                title: 'Configurações',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tela de Configurações (a implementar)')),
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                  label: Text('Sair', style: AppTheme.buttonText.copyWith(fontSize: 16)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}