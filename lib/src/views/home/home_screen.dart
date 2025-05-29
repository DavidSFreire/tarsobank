import 'package:flutter/material.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/utils/sidebar.dart';
import 'package:tarsobank/src/views/profile/profile_screen.dart';
import 'package:tarsobank/src/views/quotation/quotation_screen.dart';
import 'package:tarsobank/src/utils/botton_button.dart';
import 'package:tarsobank/src/views/transfer/transfer_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late User _currentUser; // Estado para o usuário, permitindo atualizações
  late List<Widget> _mainScreenTabs;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user; // Inicializa com o usuário passado
    // _mainScreenTabs será definido no método build para usar _currentUser atualizado
  }

  // Handler para cliques nos itens do GridView
  // O índice aqui corresponde à ordem dos HomeActionButton no GridView
  void _handleGridItemTap(int gridItemIndex, BuildContext context) async {
    switch (gridItemIndex) {
      case 0: // Carteira (Primeiro item do Grid)
        // Se 'Carteira' for uma aba da BottomNavigationBar (índice 1)
        if (_selectedIndex != 1) {
          setState(() {
            _selectedIndex = 1;
          });
        }
        break;
      case 1: // Transferência (Segundo item do Grid)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferScreen(currentUser: _currentUser),
          ),
        );

        break;
      case 2: // Saque (Terceiro item do Grid)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tela de Saque (a implementar)')),
        );
        break;
      // Adicione casos para outros botões do grid conforme a ordem:
      // Recarga, Pagamentos, Cotação, Cartão, Comprovantes, Perfil
      case 5: // Cotação (Sexto item do Grid)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuotationScreen()),
        );
        break;
      case 8: // Perfil (Nono item do Grid)
        final User? updatedUserFromProfile = await Navigator.push<User>(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: _currentUser),
          ),
        );
        if (updatedUserFromProfile != null && mounted) {
          setState(() {
            _currentUser =
                updatedUserFromProfile; // Atualiza se o perfil modificar o usuário
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

  // Helper para obter o label do grid (opcional, para mensagens)
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
    // Lógica para a BottomNavigationBar
    // Os índices aqui são 0:Home, 1:Carteira, 2:Cotação, 3:Perfil
    if (index == 2) {
      // Cotação
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QuotationScreen()),
      );
    } else if (index == 3) {
      // Perfil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: _currentUser),
        ),
      );
    } else {
      // Home (index 0) ou Carteira (index 1)
      setState(() {
        _selectedIndex = index;
      });
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
      // Se for para uma aba gerenciada pelo IndexedStack (Home ou Carteira)
      if (tabIndex == 0 || tabIndex == 1) {
        setState(() {
          _selectedIndex = tabIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define _mainScreenTabs aqui para que use o _currentUser mais recente
    _mainScreenTabs = <Widget>[
      _buildHomeScreenContent(
        context,
        _currentUser,
        _handleGridItemTap,
      ), // Aba Home
      const Scaffold(
        body: Center(child: Text('Tela de Carteira (Futura)')),
      ), // Aba Carteira
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
        title: Text(
          'Olá, ${_currentUser.name.split(' ')[0]}',
        ), // Usa _currentUser
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Ação de notificações
            },
          ),
        ],
      ),
      drawer: AppSidebar(
        user: _currentUser, // Passa _currentUser para o Sidebar
        onNavigateToTab: (sidebarTabIndex) {
          // Ajuste os índices conforme os itens da sua sidebar
          if (sidebarTabIndex == 1) {
            // Exemplo: Carteira na sidebar
            _handleSidebarNavigation(1); // Vai para a aba Carteira
          }
          if (sidebarTabIndex == 3) {
            // Exemplo: Perfil na sidebar
            _handleSidebarNavigation(
              0, // Pode definir para qual aba voltar, ou não mudar _selectedIndex
              screenToPush: ProfileScreen(user: _currentUser),
            );
          }
          if (sidebarTabIndex == 2) {
            _handleSidebarNavigation(2);
            screenToPush:
            TransferScreen(currentUser: _currentUser);
          }
          // Adicione outras navegações da sidebar
        },
      ),
      body: IndexedStack(index: _selectedIndex, children: _mainScreenTabs),
      bottomNavigationBar: Container(
        // Estilização da BottomNavigationBar... (mantida como no seu original)
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
                index: 0, // Home
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.account_balance_wallet,
                iconData: Icons.account_balance_wallet_outlined,
                index: 1, // Carteira
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.bar_chart,
                iconData: Icons.bar_chart_outlined,
                index: 2, // Cotação
              ),
              _buildBottomNavigationBarItem(
                activeIconData: Icons.person,
                iconData: Icons.person_outline,
                index: 3, // Perfil
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

  // Método para construir itens da BottomNavigationBar (mantido como no seu original)
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

// Widget para construir o conteúdo principal da HomeScreen (aba Home)
Widget _buildHomeScreenContent(
  BuildContext context,
  User user, // Recebe _currentUser
  Function(int, BuildContext) onGridItemTapped, // Callback para o State
) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saldo atual',
          style: AppTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'R\$${user.balance.toStringAsFixed(2)}', // Exibe o saldo do _currentUser
          style: AppTheme.headlineLarge?.copyWith(
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
            // A ordem dos HomeActionButton aqui define o 'gridItemIndex'
            HomeActionButton(
              // gridItemIndex = 0
              icon: Icons.account_balance_wallet_outlined,
              label: 'Carteira',
              onTap: () => onGridItemTapped(0, context),
            ),
            HomeActionButton(
              // gridItemIndex = 1
              icon: Icons.swap_horiz_outlined,
              label: 'Transferência',
              onTap: () => onGridItemTapped(1, context),
            ),
            HomeActionButton(
              // gridItemIndex = 2
              icon: Icons.savings_outlined,
              label: 'Saque',
              onTap: () => onGridItemTapped(2, context),
            ),
            HomeActionButton(
              // gridItemIndex = 3
              icon: Icons.system_update_alt_outlined,
              label: 'Recarga',
              onTap: () => onGridItemTapped(3, context),
            ),
            HomeActionButton(
              // gridItemIndex = 4
              icon: Icons.receipt_long_outlined,
              label: 'Pagamentos',
              onTap: () => onGridItemTapped(4, context),
            ),
            HomeActionButton(
              // gridItemIndex = 5
              icon: Icons.trending_up_outlined,
              label: 'Cotação',
              onTap: () => onGridItemTapped(5, context),
            ),
            HomeActionButton(
              // gridItemIndex = 6
              icon: Icons.credit_card_outlined,
              label: 'Cartão de crédito',
              onTap: () => onGridItemTapped(6, context),
            ),
            HomeActionButton(
              // gridItemIndex = 7
              icon: Icons.article_outlined,
              label: 'Comprovantes',
              onTap: () => onGridItemTapped(7, context),
            ),
            HomeActionButton(
              // gridItemIndex = 8
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
