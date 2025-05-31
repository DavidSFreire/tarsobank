import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:tarsobank/src/database/models/user_model.dart';
import 'package:tarsobank/src/utils/theme.dart';

PdfColor _flutterColorToPdfColorUtil(Color color) {
  return PdfColor.fromInt(color.value);
}

pw.Widget _buildPdfSectionUtil(String title, List<String> details) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: <pw.Widget>[
      pw.Text(
        title,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 3),
      ...details.map(
        (text) => pw.Padding(
          padding: const pw.EdgeInsets.only(left: 5),
          child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
        ),
      ),
      pw.SizedBox(height: 12),
    ],
  );
}

Future<Uint8List> _generatePdfBytesForReceipt({
  required User currentUser,
  required String receiverName,
  required String receiverAccountNumber,
  required double amountTransferred,
  required DateTime transactionDateTime,
  required String? transactionDescription,
}) async {
  final pdf = pw.Document();
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss', 'pt_BR');
  final String formattedDateTime = formatter.format(transactionDateTime);

  final PdfColor primaryDarkColor = _flutterColorToPdfColorUtil(
    AppTheme.primaryDark,
  );
  final PdfColor primaryLightColor = _flutterColorToPdfColorUtil(
    AppTheme.primaryLight,
  );
  const PdfColor textSecondaryColorPdf = PdfColors.grey600;

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Text(
                    'Comprovante de Transferência',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryDarkColor,
                    ),
                  ),
                  pw.Text(
                    'Tarsobank',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: textSecondaryColorPdf,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 15),
            pw.Text(
              'Valor Transferido:',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: primaryDarkColor,
              ),
            ),
            pw.Text(
              'R\$${amountTransferred.toStringAsFixed(2)}',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: primaryLightColor,
              ),
            ),
            pw.SizedBox(height: 20),
            _buildPdfSectionUtil('De:', [
              currentUser.name,
              'Agência: ${currentUser.agency ?? 'N/A'} / Conta: ${currentUser.accountNumber ?? 'N/A'}',
            ]),
            _buildPdfSectionUtil('Para:', [
              receiverName,
              'Conta: $receiverAccountNumber',
            ]),
            if (transactionDescription != null &&
                transactionDescription.isNotEmpty)
              _buildPdfSectionUtil('Descrição:', [transactionDescription]),
            pw.Divider(height: 30),
            _buildPdfSectionUtil('Data e Hora da Transação:', [
              formattedDateTime,
            ]),
            pw.Spacer(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Future<void> generateAndSharePdfReceipt({
  required BuildContext context,
  required User currentUser,
  required String receiverName,
  required String receiverAccountNumber,
  required double amountTransferred,
  required DateTime transactionDateTime,
  String? transactionDescription,
}) async {
  try {
    final Uint8List pdfBytes = await _generatePdfBytesForReceipt(
      currentUser: currentUser,
      receiverName: receiverName,
      receiverAccountNumber: receiverAccountNumber,
      amountTransferred: amountTransferred,
      transactionDateTime: transactionDateTime,
      transactionDescription: transactionDescription,
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/comprovante_tarsobank.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    final XFile pdfXFile = XFile(filePath);

    await Share.shareXFiles(
      [pdfXFile],
      text: 'Comprovante de Transferência - Tarsobank',
      subject: 'Comprovante de Transferência Tarsobank',
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar ou compartilhar PDF: ${e.toString()}'),
        ),
      );
    }
  }
}
