import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tarsobank/src/api/viacep.dart';

class EnderecoDialog extends StatefulWidget {
  const EnderecoDialog({super.key});

  @override
  State<EnderecoDialog> createState() => _EnderecoDialogState();
}

class _EnderecoDialogState extends State<EnderecoDialog> {
  final _formKey = GlobalKey<FormState>();
  final rua = TextEditingController();
  final numero = TextEditingController();
  final complemento = TextEditingController();
  final bairro = TextEditingController();
  final cidade = TextEditingController();
  final estado = TextEditingController();
  final cep = TextEditingController();

  final ViaCepService _viaCepService = ViaCepService();
  bool _isLoadingCep = false;
  String? _cepError;

  late MaskTextInputFormatter cepFormatter;

  @override
  void initState() {
    super.initState();
    cepFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  Future<void> _buscarCep() async {
    final unmaskedCep = cepFormatter.getUnmaskedText();
    if (unmaskedCep.length == 8) {
      setState(() {
        _isLoadingCep = true;
        _cepError = null;
        rua.clear();
        bairro.clear();
        cidade.clear();
        estado.clear();
      });

      try {
        final enderecoData = await _viaCepService.fetchCep(unmaskedCep);
        if (mounted) {
          if (enderecoData != null && !enderecoData.erro) {
            rua.text = enderecoData.logradouro;
            bairro.text = enderecoData.bairro;
            cidade.text = enderecoData.localidade;
            estado.text = enderecoData.uf;
          } else if (enderecoData != null && enderecoData.erro) {
            setState(() {
              _cepError = 'CEP não encontrado.';
            });
          } else {
            setState(() {
              _cepError = 'Não foi possível obter os dados do CEP.';
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _cepError =
                'Erro ao buscar CEP: ${e.toString().substring(0, (e.toString().length > 50) ? 50 : e.toString().length)}...';
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingCep = false;
          });
        }
      }
    } else {
      if (rua.text.isNotEmpty ||
          bairro.text.isNotEmpty ||
          cidade.text.isNotEmpty ||
          estado.text.isNotEmpty) {
        setState(() {
          rua.clear();
          bairro.clear();
          cidade.clear();
          estado.clear();
          _cepError = null;
        });
      }
    }
  }

  @override
  void dispose() {
    rua.dispose();
    numero.dispose();
    complemento.dispose();
    bairro.dispose();
    cidade.dispose();
    estado.dispose();
    cep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: cep,
                keyboardType: TextInputType.number,
                inputFormatters: [cepFormatter],
                decoration: InputDecoration(
                  labelText: 'CEP',
                  hintText: '00000-000',
                  border: const OutlineInputBorder(),
                  errorText: _cepError,
                  suffixIcon:
                      _isLoadingCep
                          ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP é obrigatório';
                  }
                  if (cepFormatter.getUnmaskedText().length != 8 &&
                      _cepError == null) {
                    return 'CEP inválido';
                  }
                  return null;
                },

                onChanged: (value) {
                  if (_cepError != null) {
                    setState(() {
                      _cepError = null;
                    });
                  }
                  if (cepFormatter.getUnmaskedText().length == 8) {
                    _buscarCep();
                  } else if (cepFormatter.getUnmaskedText().isEmpty) {
                    rua.clear();
                    bairro.clear();
                    cidade.clear();
                    estado.clear();
                    complemento.clear();
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: rua,
                decoration: const InputDecoration(
                  labelText: 'Rua',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Rua é obrigatória'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: numero,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Número é obrigatório'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: complemento,
                decoration: const InputDecoration(
                  labelText: 'Complemento (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bairro,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Bairro é obrigatório'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cidade,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Cidade é obrigatória'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: estado,
                decoration: const InputDecoration(
                  labelText: 'Estado (UF)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Estado é obrigatório';
                  if (value.length != 2) return 'UF inválida (ex: SP)';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final enderecoCompleto = {
                'cep': cep.text,
                'rua': rua.text,
                'numero': numero.text,
                'complemento': complemento.text,
                'bairro': bairro.text,
                'cidade': cidade.text,
                'estado': estado.text,
              };
              final String enderecoFormatado =
                  '${rua.text}, ${numero.text}${complemento.text.isNotEmpty ? ' - ${complemento.text}' : ''}, '
                  '${bairro.text}, ${cidade.text} - ${estado.text}, CEP: ${cep.text}';
              Navigator.pop(context, enderecoFormatado);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
