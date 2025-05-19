# Tarsobank

Aplicativo de banco digital desenvolvido com Flutter. O Tarsobank irá permitir aos usuários realizar transferências, visualizar cotações de moedas, gerenciar perfil, entre outras funcionalidades bancárias.

## 📁 Estrutura do Projeto

```
tarsobank/
├── android/
├── ios/
├── lib/
│   ├── src/
│   │   ├── api/                  # Conexões com APIs externas
│   │   │   └── exchange_api.dart # API de cotações
│   │   ├── database/             # Configuração do banco de dados
│   │   │   └── local_db.dart     # SQFlite ou Hive
│   │   ├── models/               # Modelos de dados
│   │   │   ├── user_model.dart
│   │   │   └── transaction_model.dart
│   │   ├── repositories/         # Repositórios para gerenciar dados
│   │   │   ├── auth_repository.dart
│   │   │   └── user_repository.dart
│   │   ├── services/             # Lógica de negócios
│   │   │   ├── auth_service.dart
│   │   │   └── transaction_service.dart
│   │   ├── utils/                # Utilitários
│   │   │   ├── constants.dart
│   │   │   ├── helpers.dart
│   │   │   └── theme.dart        # Configuração de temas
│   │   └── widgets/              # Widgets reutilizáveis
│   │       ├── custom_button.dart
│   │       ├── custom_textfield.dart
│   │       └── menu_item.dart
│   ├── views/                    # Telas do aplicativo
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── dashboard.dart    # Componentes da tela inicial
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   ├── transfer/
│   │   │   └── transfer_screen.dart
│   │   ├── quotation/
│   │   │   └── quotation_screen.dart
│   │   └── splash_screen.dart
│   └── main.dart                 # Ponto de entrada
├── pubspec.yaml
└── test/                         # Testes
```

## 🚀 Funcionalidades futuras

- Autenticação de usuários
- Tela de login e cadastro
- Tela inicial com dashboard
- Transferência de valores
- Consulta de cotações de moedas
- Gerenciamento de perfil
- Temas personalizados
- Banco de dados local
