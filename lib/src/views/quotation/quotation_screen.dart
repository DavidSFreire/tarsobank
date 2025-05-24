import 'package:flutter/material.dart';
import 'package:tarsobank/src/api/exchange_api.dart';
import 'package:tarsobank/src/utils/theme.dart';

class QuotationScreen extends StatefulWidget {
  const QuotationScreen({Key? key}) : super(key: key);

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  final CurrencyService currencyService = CurrencyService();

  String fromCurrency = 'USD';
  String toCurrency = 'BRL';
  double exchangeRate = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  Future<void> fetchExchangeRate() async {
    setState(() => isLoading = true);

    try {
      final rate = await currencyService.fetchExchangeRate(fromCurrency, toCurrency);
      setState(() {
        exchangeRate = rate;
      });
    } catch (e) {
      debugPrint('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar cotação')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void convertCurrency() {
    final amount = double.tryParse(fromController.text);
    if (amount != null && exchangeRate > 0) {
      final result = amount * exchangeRate;
      toController.text = result.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Cotação atual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              'assets/images/exchange.png',
              height: 200,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Campo "De"
                    TextFormField(
                      controller: fromController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'De',
                        suffixIcon: DropdownButton<String>(
                          value: fromCurrency,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'USD', child: Text('USD')),
                            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                            DropdownMenuItem(value: 'BRL', child: Text('BRL')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                fromCurrency = value;
                                fetchExchangeRate();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Ícones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_downward, color: Colors.blue),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_upward, color: Colors.pink),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Campo "Para"
                    TextFormField(
                      controller: toController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Para',
                        suffixIcon: DropdownButton<String>(
                          value: toCurrency,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'USD', child: Text('USD')),
                            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                            DropdownMenuItem(value: 'BRL', child: Text('BRL')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                toCurrency = value;
                                fetchExchangeRate();
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Texto da cotação atual
                    isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Cotação Atual\n1 $fromCurrency = ${exchangeRate.toStringAsFixed(2)} $toCurrency',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                    const SizedBox(height: 16),

                    // Botão converter
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: convertCurrency,
                        child: const Text('Converter'),
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
}
