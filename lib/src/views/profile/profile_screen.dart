import 'package:flutter/material.dart';
import 'package:tarsobank/src/database/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  Widget _buildInfoField(BuildContext context, String label, String value, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadows,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullAddressDialog(BuildContext context, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Endereço Completo'),
          content: SingleChildScrollView(
            child: Text(address),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Perfil'),
        backgroundColor: AppTheme.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: user,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 24.0, top: 8.0),
              child: Text(
                'Sua Informação de perfil',
                style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.primaryLight.withOpacity(0.2),
                    child: Icon(Icons.person, size: 80, color: AppTheme.primaryDark),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.cardColor, width: 2),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: Text(
                'Informação Pessoal',
                style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
              ),
            ),
            _buildInfoField(context, 'Numero da conta', user.accountNumber),
            _buildInfoField(context, 'Agência', user.agency),
            _buildInfoField(context, 'Nome de Usuário', user.name),
            _buildInfoField(context, 'Cpf', user.cpf),
            _buildInfoField(context, 'Email', user.email),
            _buildInfoField(context, 'Telefone', user.phone),
            _buildInfoField(
              context,
              'Endereço',
              user.address,
              onTap: () => _showFullAddressDialog(context, user.address),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}