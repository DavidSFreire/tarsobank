import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              TextFormField(  keyboardType: TextInputType.number,
               inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(8),],
              controller: cep, decoration: const InputDecoration(labelText: 'CEP')),
              TextFormField(controller: rua, decoration: const InputDecoration(labelText: 'Rua')),
              TextFormField(controller: numero, decoration: const InputDecoration(labelText: 'Número')),
              TextFormField(controller: complemento, decoration: const InputDecoration(labelText: 'Complemento')),
              TextFormField(controller: bairro, decoration: const InputDecoration(labelText: 'Bairro')),
              TextFormField(controller: cidade, decoration: const InputDecoration(labelText: 'Cidade')),
              TextFormField(controller: estado, decoration: const InputDecoration(labelText: 'Estado')),
              
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
              final endereco = '${rua.text}, ${numero.text} ${complemento.text}, '
                  '${bairro.text}, ${cidade.text} - ${estado.text}, CEP: ${cep.text}';
              Navigator.pop(context, endereco);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
