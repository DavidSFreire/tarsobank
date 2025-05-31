import 'package:flutter/material.dart';
import 'package:tarsobank/src/database/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';
import 'package:tarsobank/src/utils/pdf_share.dart';

class SuccessTransferScreen extends StatefulWidget {
  final User currentUser;
  final String receiverName;
  final String receiverAccountNumber;
  final double amountTransferred;
  final DateTime transactionDateTime;
  final String? transactionDescription;

  const SuccessTransferScreen({
    super.key,
    required this.currentUser,
    required this.receiverName,
    required this.receiverAccountNumber,
    required this.amountTransferred,
    required this.transactionDateTime,
    this.transactionDescription,
  });

  @override
  State<SuccessTransferScreen> createState() => _SuccessTransferScreenState();
}

class _SuccessTransferScreenState extends State<SuccessTransferScreen> {
  bool _isProcessingPdf = false;

  Future<void> _handleSharePdf() async {
    if (_isProcessingPdf) return;
    setState(() => _isProcessingPdf = true);

    await generateAndSharePdfReceipt(
      context: context,
      currentUser: widget.currentUser,
      receiverName: widget.receiverName,
      receiverAccountNumber: widget.receiverAccountNumber,
      amountTransferred: widget.amountTransferred,
      transactionDateTime: widget.transactionDateTime,
      transactionDescription: widget.transactionDescription,
    );

    if (mounted) {
      setState(() => _isProcessingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transferência Concluída',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppTheme.primaryDark,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Transferência Realizada!',
              textAlign: TextAlign.center,
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Você transferiu R\$${widget.amountTransferred.toStringAsFixed(2)} para ${widget.receiverName}.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
            ),
            if (widget.transactionDescription != null &&
                widget.transactionDescription!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Descrição: ${widget.transactionDescription}',
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon:
                  _isProcessingPdf
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                      : const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: Text(
                _isProcessingPdf
                    ? 'Gerando PDF...'
                    : 'Compartilhar Comprovante PDF',
                style: AppTheme.buttonText.copyWith(color: Colors.white),
              ),
              onPressed: _isProcessingPdf ? null : _handleSharePdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,'/home',
                  (Route<dynamic> route) => false,
                  arguments: widget.currentUser,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Voltar ao Início',
                style: AppTheme.buttonText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
