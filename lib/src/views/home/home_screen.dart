import 'package:flutter/material.dart';
import 'package:tarsobank/src/database/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/utils/sidebar.dart';
import 'package:tarsobank/src/utils/botton_button.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late User _currentUser;
  late List<Widget> _mainScreenTabs;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _handleGridItemTap(int gridItemIndex, BuildContext context) async {
    switch (gridItemIndex) {
      case 0:
        if (_selectedIndex != 1) {
          setState(() {
            _selectedIndex = 1;
          });
        }
        break;
      case 1:
        Navigator.pushNamed(context, '/transfer', arguments: _currentUser);
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela de Saque (a implementar)')),
        );
        break;
      case 5:
        Navigator.pushNamed(context, '/quotation');
        break;
      case 8:
        final User? updatedUserFromProfile =
            await Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: _currentUser,
                )
                as User?;
        if (updatedUserFromProfile != null && mounted) {
          setState(() {
            _currentUser = updatedUserFromProfile;
          });
        }
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ação para "${_getGridLabel(gridItemIndex)}" (a implementar)',
            ),
          ),
        );
        break;
    }
  }

  String _getGridLabel(int index) {
    const labels = [
      'Carteira',
      'Transferência',
      'Saque',
      'Recarga',
      'Pagamentos',
      'Cotação',
      'Cartão de crédito',
      'Comprovantes',
      'Perfil',
    ];
    return (index >= 0 && index < labels.length)
        ? labels[index]
        : 'Item $index';
  }

  void _handleBottomNavTap(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/quotation');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile', arguments: _currentUser);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handleSidebarNavigation(String routeName, {User? userArgument}) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName, arguments: userArgument);
  }

  @override
  Widget build(BuildContext context) {
    _mainScreenTabs = <Widget>[
      _buildHomeScreenContent(context, _currentUser, _handleGridItemTap),
      const Scaffold(body: Center(child: Text('Tela de Carteira (Futura)'))),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text('Olá, ${_currentUser.name.split(' ')[0]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppSidebar(
        user: _currentUser,
        onNavigateToTab: (sidebarTabIndex) {
          if (sidebarTabIndex == 1) {
            _handleSidebarNavigation('/home', userArgument: _currentUser);
          }
          if (sidebarTabIndex == 3) {
            _handleSidebarNavigation('/profile', userArgument: _currentUser);
          }
          if (sidebarTabIndex == 2) {
            _handleSidebarNavigation('/transfer', userArgument: _currentUser);
          }
        },
      ),
      body: IndexedStack(index: _selectedIndex, children: _mainScreenTabs),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.textPrimary.withAlpha((0.1 * 255).round()),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              _buildBottomNavigationBarItem(
                activeIconData: Icons.home_filled,
                iconData: Icons.home_outlined,
                index: 0,
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.account_balance_wallet,
                iconData: Icons.account_balance_wallet_outlined,
                index: 1,
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.bar_chart,
                iconData: Icons.bar_chart_outlined,
                index: 2,
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.person,
                iconData: Icons.person_outline,
                index: 3,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _handleBottomNavTap,
            backgroundColor: AppTheme.cardColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData activeIconData,
    required IconData iconData,
    required int index,
  }) {
    bool isActive = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20.0 : 10.0,
          vertical: isActive ? 10.0 : 8.0,
        ),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppTheme.primaryLight.withAlpha((0.25 * 255).round())
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          isActive ? activeIconData : iconData,
          color: isActive ? AppTheme.primaryDark : AppTheme.textDisabled,
          size: 26,
        ),
      ),
      label: '',
    );
  }
}

Widget _buildHomeScreenContent(
  BuildContext context,
  User user,
  Function(int, BuildContext) onGridItemTapped,
) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saldo atual',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'R\$${user.balance.toStringAsFixed(2)}',
          style: AppTheme.headlineLarge.copyWith(
            color: AppTheme.primaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          children: [
            HomeActionButton(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Carteira',
              onTap: () => onGridItemTapped(0, context),
            ),
            HomeActionButton(
              icon: Icons.swap_horiz_outlined,
              label: 'Transferência',
              onTap: () => onGridItemTapped(1, context),
            ),
            HomeActionButton(
              icon: Icons.savings_outlined,
              label: 'Saque',
              onTap: () => onGridItemTapped(2, context),
            ),
            HomeActionButton(
              icon: Icons.system_update_alt_outlined,
              label: 'Recarga',
              onTap: () => onGridItemTapped(3, context),
            ),
            HomeActionButton(
              icon: Icons.receipt_long_outlined,
              label: 'Pagamentos',
              onTap: () => onGridItemTapped(4, context),
            ),
            HomeActionButton(
              icon: Icons.trending_up_outlined,
              label: 'Cotação',
              onTap: () => onGridItemTapped(5, context),
            ),
            HomeActionButton(
              icon: Icons.credit_card_outlined,
              label: 'Cartão de crédito',
              onTap: () => onGridItemTapped(6, context),
            ),
            HomeActionButton(
              icon: Icons.article_outlined,
              label: 'Comprovantes',
              onTap: () => onGridItemTapped(7, context),
            ),
            HomeActionButton(
              icon: Icons.person_outline,
              label: 'Perfil',
              onTap: () => onGridItemTapped(8, context),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}
