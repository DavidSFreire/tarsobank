# TarsoBank

![TarsoBank](https://user-images.githubusercontent.com/49309239/236841600-932216e5-e7e8-4a6d-add4-1e0c60a09701.png)

## 🎯 Sobre

O TarsoBank é um projeto de aplicativo de banco digital desenvolvido com o principal objetivo de aprendizado do framework Flutter. Através da construção deste aplicativo, busca-se aprofundar o conhecimento sobre diversas funcionalidades e conceitos do Flutter, incluindo a integração com APIs, o uso de plugins diversos, a implementação de rotas de navegação (page routers), gerenciamento de estado, e outras tecnologias e padrões comumente utilizados no desenvolvimento de aplicativos móveis com esta ferramenta. O contexto de um banco digital serve como um estudo de caso prático para aplicar e explorar esses recursos.

## ✨ Funcionalidades Principais

* **Autenticação de Usuário:** Telas de Login e Cadastro para acesso seguro.
* **Dashboard:** Tela inicial com um resumo das informações financeiras do usuário.
* **Transferências:** Funcionalidade para realizar transferências de valores.
* **Cotação de Moedas:** Visualização de cotações de moedas (ex: integração com API de câmbio).
* **Gerenciamento de Perfil:** Tela para o usuário visualizar e gerenciar suas informações.

## 📁 Estrutura do Projeto

O projeto está organizado da seguinte forma:
```
tarsobank/
├── android/                # Código específico para a plataforma Android
├── ios/                    # Código específico para a plataforma iOS
├── linux/                  # Código específico para a plataforma Linux
├── macos/                  # Código específico para a plataforma macOS
├── web/                    # Código específico para a plataforma Web
├── windows/                # Código específico para a plataforma Windows
├── lib/                    # Contém todo o código Dart da aplicação
│   ├── src/                # Lógica de negócio, serviços, modelos, etc.
│   │   ├── api/            # Lógica de integração com APIs externas (ex: exchange_api.dart)
│   │   ├── database/       # Configuração e gerenciamento do banco de dados local
│   │   ├── models/         # Modelos de dados da aplicação (ex: user_model.dart, transaction_model.dart)
│   │   ├── repositories/   # Repositórios para abstrair a origem dos dados
│   │   ├── services/       # Serviços da aplicação
│   │   ├── utils/          # Utilitários e helpers
│   │   └── widgets/        # Widgets reutilizáveis da interface gráfica
│   ├── views/              # Telas da aplicação (interface do usuário)
│   │   ├── auth/           # Telas relacionadas à autenticação
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/           # Telas principais após o login
│   │   │   ├── home_screen.dart
│   │   │   └── dashboard.dart
│   │   ├── profile/        # Tela de perfil do usuário
│   │   │   └── profile_screen.dart
│   │   ├── transfer/       # Tela para realizar transferências
│   │   │   └── transfer_screen.dart
│   │   ├── quotation/      # Tela para visualização de cotações
│   │   │   └── quotation_screen.dart
│   │   └── splash_screen.dart # Tela de apresentação inicial
│   └── main.dart           # Ponto de entrada principal da aplicação
├── test/                   # Arquivos de teste
├── pubspec.yaml            # Arquivo de configuração de dependências e metadados do projeto
└── README.md               # Este arquivo :)
```

## Telas Principais

O aplicativo conta com as seguintes telas principais:

1.  **SplashScreen (`splash_screen.dart`):**
    * **Descrição:** Tela inicial exibida durante o carregamento do aplicativo.

2.  **Tela de Login (`auth/login_screen.dart`):**
    * **Descrição:** Permite que usuários existentes acessem suas contas.
    * **Funcionalidades:** Campos para e-mail/usuário e senha, botão de login.

3.  **Tela de Cadastro (`auth/register_screen.dart`):**
    * **Descrição:** Permite que novos usuários criem uma conta.
    * **Funcionalidades:** Campos para informações pessoais e de login, botão de registro.

4.  **Tela Inicial / Dashboard (`home/home_screen.dart` e `home/dashboard.dart`):**
    * **Descrição:** Tela principal após o login, exibindo um resumo das atividades financeiras, saldo, e acesso rápido a outras funcionalidades.
    * **Funcionalidades:** Visualização de saldo, atalhos para transferências, extrato (se implementado), cotações.

5.  **Tela de Perfil (`profile/profile_screen.dart`):**
    * **Descrição:** Permite ao usuário visualizar e, possivelmente, editar suas informações pessoais e configurações da conta.
    * **Funcionalidades:** Exibição de dados do usuário, opções de configuração.

6.  **Tela de Transferência (`transfer/transfer_screen.dart`):**
    * **Descrição:** Interface para o usuário realizar transferências de valores para outras contas.
    * **Funcionalidades:** Seleção de destinatário, valor da transferência, confirmação.

7.  **Tela de Cotação (`quotation/quotation_screen.dart`):**
    * **Descrição:** Exibe cotações de moedas ou outros ativos financeiros.
    * **Funcionalidades:** Lista de moedas e seus valores atualizados.

## 🛠 Tecnologias Utilizadas

* **Flutter:** Framework de desenvolvimento de interface de usuário para criar aplicativos compilados nativamente para mobile, web e desktop a partir de uma única base de código.
* **Dart:** Linguagem de programação utilizada pelo Flutter.

## 🚀 Como Executar 

1.  Clone o repositório: `git clone https://github.com/DavidSFreire/tarsobank.git`
2.  Navegue até o diretório do projeto: `cd tarsobank`
3.  Instale as dependências: `flutter pub get`
4.  Execute o aplicativo: `flutter run`

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

---
