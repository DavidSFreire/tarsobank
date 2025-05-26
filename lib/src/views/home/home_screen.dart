import 'package:flutter/material.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/home/sidebar.dart';
import 'package:tarsobank/src/views/profile/profile_screen.dart';
import 'package:tarsobank/src/views/quotation/quotation_screen.dart';
import 'package:tarsobank/src/views/home/botton_button.dart';


class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> _mainScreenTabs;

  @override
  void initState() {
    super.initState();
    _mainScreenTabs = <Widget>[
      _buildHomeScreenContent(context, widget.user, _handleGridItemTap),
      const Scaffold(body: Center(child: Text('Tela de Carteira (Futura)'))),
    ];
  }

  void _handleGridItemTap(int index) {
    if (index == 1) { // Carteira
      setState(() {
        _selectedIndex = 1;
      });
    } else if (index == 2) { // Cotação
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuotationScreen()),
      );
    } else if (index == 3) { // Perfil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
      );
    }
  }

  void _handleBottomNavTap(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuotationScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
      );
    }
  }

  void _handleSidebarNavigation(int tabIndex, {Widget? screenToPush}) {
    Navigator.pop(context); // Fecha o Drawer
    if (screenToPush != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screenToPush),
      );
    } else {
       if (tabIndex == 0 || tabIndex == 1) {
         setState(() {
           _selectedIndex = tabIndex;
         });
       }
    }
  }


  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Olá, ${widget.user.name.split(' ')[0]}',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppSidebar(
        user: widget.user,
        onNavigateToTab: (tabIndex) {
          if (tabIndex == 1) { // Carteira
             _handleSidebarNavigation(tabIndex);
          } else if (tabIndex == 3) { // Perfil
             _handleSidebarNavigation(0, screenToPush: ProfileScreen(user: widget.user));
          }
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _mainScreenTabs,
      ),
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
          color: isActive ? AppTheme.primaryLight.withAlpha((0.25 * 255).round()) : Colors.transparent,
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

Widget _buildHomeScreenContent(BuildContext context, User user, Function(int) onGridItemTapped) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saldo atual',
          style: AppTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          'R\$800.00',
          style: AppTheme.headlineLarge
              ?.copyWith(color: AppTheme.primaryLight, fontWeight: FontWeight.bold),
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
              onTap: () {
                onGridItemTapped(1);
              },
            ),
            HomeActionButton(
              icon: Icons.swap_horiz_outlined,
              label: 'Transferência',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Transferência (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.savings_outlined,
              label: 'Saque',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Saque (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.system_update_alt_outlined,
              label: 'Recarga',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Recarga (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.receipt_long_outlined,
              label: 'Pagamentos',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Pagamentos (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.trending_up_outlined,
              label: 'Cotação',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuotationScreen()),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.credit_card_outlined,
              label: 'Cartão de crédito',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Cartão de Crédito (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.article_outlined,
              label: 'Comprovantes',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tela de Comprovantes (a implementar)')),
                );
              },
            ),
            HomeActionButton(
              icon: Icons.person_outline,
              label: 'Perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}
