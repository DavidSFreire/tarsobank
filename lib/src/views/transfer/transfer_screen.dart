// src/views/transfer/transfer_screen.dart
import 'package:flutter/material.dart';
import 'package:tarsobank/src/database/local_db.dart';
import 'package:tarsobank/src/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/views/transfer/success_transfer_screen.dart';

class TransferScreen extends StatefulWidget {
  final User currentUser;

  const TransferScreen({super.key, required this.currentUser});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController(); // Para a senha
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late User _updatedCurrentUser;
  bool _isPasswordVisible = false; // Para controlar a visibilidade da senha

  @override
  void initState() {
    super.initState();
    _updatedCurrentUser = widget.currentUser;
  }

  Future<void> _performTransfer() async {
    if (_formKey.currentState!.validate()) {
      final String receiverAccountNumber = _accountNumberController.text.trim();
      final double amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final String description = _descriptionController.text.trim();

      if (receiverAccountNumber == _updatedCurrentUser.accountNumber) {
        _showSnackBar('Você não pode transferir para sua própria conta.', Colors.orange);
        return;
      }

      if (amount <= 0) {
        _showSnackBar('O valor da transferência deve ser positivo.', Colors.red);
        return;
      }

      if (_updatedCurrentUser.balance < amount) {
        _showSnackBar('Saldo insuficiente para realizar a transferência.', Colors.red);
        return;
      }

      // 1. Buscar dados do usuário destinatário para exibir o nome
      User? receiverUser = await _dbHelper.getUserByAccountNumber(receiverAccountNumber);

      if (receiverUser == null) {
        _showSnackBar('Conta de destino não encontrada.', Colors.red);
        return;
      }

      // Limpar o campo de senha antes de mostrar o diálogo
      _passwordConfirmationController.clear();
      setState(() {
        _isPasswordVisible = false; // Resetar visibilidade da senha
      });


      // 2. Mostrar diálogo de confirmação com nome do destinatário e campo de senha
      bool? confirmedWithPassword = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Impede fechar clicando fora
        builder: (BuildContext dialogContext) {
          // Usar um StatefulBuilder para gerenciar o estado da visibilidade da senha dentro do diálogo
          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: const Text('Confirmar Transferência'),
                content: SingleChildScrollView( // Para evitar overflow se o teclado aparecer
                  child: ListBody(
                    children: <Widget>[
                      Text('Você deseja transferir R\$${amount.toStringAsFixed(2)} para:'),
                      const SizedBox(height: 8),
                      Text(
                        receiverUser.name, // Exibe o nome do destinatário
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Conta: ${receiverUser.accountNumber}'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Sua Senha',
                          hintText: 'Digite sua senha para confirmar',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              // Atualiza o estado do diálogo para mostrar/ocultar senha
                              setStateDialog(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                              // Também atualiza o estado da tela principal se necessário,
                              // mas o setStateDialog é mais focado.
                              // Para garantir que o estado da tela principal também seja atualizado:
                              setState(() {
                                  _isPasswordVisible = _isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                  ),
                  ElevatedButton( // Usar ElevatedButton para dar mais destaque à confirmação
                    child: const Text('Confirmar'),
                    onPressed: () async {
                      // Validar a senha aqui mesmo
                      if (_passwordConfirmationController.text.isEmpty) {
                         _showSnackBarInDialog(dialogContext, 'Senha obrigatória.', Colors.red);
                        return;
                      }
                      bool isPasswordCorrect = await _dbHelper.verifyPassword(
                          _updatedCurrentUser.cpf, _passwordConfirmationController.text);

                      if (isPasswordCorrect) {
                        Navigator.of(dialogContext).pop(true);
                      } else {
                        _showSnackBarInDialog(dialogContext, 'Senha incorreta.', Colors.red);
                        // Não fechar o diálogo, permitir nova tentativa
                      }
                    },
                  ),
                ],
              );
            }
          );
        },
      );

      if (confirmedWithPassword != true) {
        return; // Usuário cancelou ou senha incorreta e não quis tentar novamente
      }

      // Mostrar Dialog de Progresso
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Processando..."),
                  ],
                ),
              ),
            );
          });

      bool success = await _dbHelper.performTransfer(
        senderUserId: _updatedCurrentUser.id!,
        receiverAccountNumber: receiverAccountNumber, // Já temos receiverUser.accountNumber também
        amount: amount,
        description: description.isNotEmpty ? description : null,
      );

      Navigator.pop(context); // Fecha o diálogo de progresso

      if (success) {
        final newBalance = _updatedCurrentUser.balance - amount;
        _updatedCurrentUser = _updatedCurrentUser.copyWith(balance: newBalance);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessTransferScreen(currentUser: _updatedCurrentUser),
          ),
        );
      } else {
        _showSnackBar('Erro ao realizar a transferência. Tente novamente.', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper para mostrar SnackBar dentro do contexto do diálogo
  void _showSnackBarInDialog(BuildContext dialogContext, String message, Color color) {
    ScaffoldMessenger.of(dialogContext).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _passwordConfirmationController.dispose(); // Dispose do controller da senha
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transferência'),
        backgroundColor: AppTheme.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seu Saldo Atual',
                style: AppTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              ),
              Text(
                'R\$${_updatedCurrentUser.balance.toStringAsFixed(2)}',
                style: AppTheme.headlineMedium?.copyWith(color: AppTheme.primaryLight, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número da Conta de Destino',
                  hintText: 'Ex: 123456',
                  prefixIcon: Icon(Icons.account_balance),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o número da conta';
                  }
                  if(value.trim() == _updatedCurrentUser.accountNumber){
                     return 'Não pode transferir para sua própria conta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Valor da Transferência (R\$)',
                  hintText: 'Ex: 50.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o valor';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Valor inválido';
                  }
                  if (amount > _updatedCurrentUser.balance) {
                    return 'Saldo insuficiente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (Opcional)',
                  hintText: 'Ex: Aluguel',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _performTransfer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryDark,
                  ),
                  child: const Text('Transferir', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}