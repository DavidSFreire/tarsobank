# TarsoBank

## 🎯 Sobre

O TarsoBank é um projeto de aplicativo de banco digital desenvolvido com o principal objetivo de aprendizado do framework Flutter. Através da construção deste aplicativo, busca-se aprofundar o conhecimento sobre diversas funcionalidades e conceitos do Flutter, incluindo:

* Integração com APIs e serviços externos.
* Uso de plugins diversos para funcionalidades específicas.
* Implementação de rotas de navegação (page routers) para uma experiência de usuário fluida.
* Gerenciamento de estado eficiente para manter a consistência da aplicação.
* Aplicação de padrões de arquitetura (como o MVC) para um código mais organizado e manutenível.
* Persistência de dados local com SQLite.
* Uso de animações para enriquecer a interface do usuário.

O contexto de um banco digital serve como um estudo de caso prático para aplicar e explorar esses recursos, oferecendo uma visão completa do desenvolvimento de aplicativos móveis com Flutter.

## ✨ Funcionalidades Principais

* **Autenticação de Usuário:** Telas de Login e Cadastro para acesso seguro.
* **Dashboard:** Tela inicial com um resumo das informações financeiras do usuário.
* **Transferências:** Funcionalidade para realizar transferências de valores.
* **Cotação de Moedas:** Visualização de cotações de moedas (integração com API de câmbio).
* **Gerenciamento de Perfil:** Tela para o usuário visualizar e gerenciar suas informações.
* **Armazenamento Local:** Persistência de dados utilizando SQLite para gerenciar informações do usuário e transações.


## Telas Principais

O aplicativo conta com as seguintes telas principais:

1.  **SplashScreen (`splash_screen.dart`):**
    * **Descrição:** Tela inicial exibida durante o carregamento do aplicativo, muitas vezes usada para carregar dados iniciais.
    * **Funcionalidades:** Apresentação da marca, transição para a tela de autenticação ou dashboard.

2.  **Tela de Login (`auth/login_screen.dart`):**
    * **Descrição:** Permite que usuários existentes acessem suas contas.
    * **Funcionalidades:** Campos para e-mail/usuário e senha, botão de login, navegação para a tela de cadastro.

3.  **Tela de Cadastro (`auth/register_screen.dart`):**
    * **Descrição:** Permite que novos usuários criem uma conta no TarsoBank.
    * **Funcionalidades:** Campos para informações pessoais e de login (nome, e-mail, senha), botão de registro.

4.  **Tela Inicial / Dashboard (`home/home_screen.dart` e `home/dashboard.dart`):**
    * **Descrição:** Tela principal após o login, exibindo um resumo das atividades financeiras, saldo, e acesso rápido a outras funcionalidades do banco.
    * **Funcionalidades:** Visualização de saldo, atalhos para transferências, extrato (se implementado), cotações de moedas.

5.  **Tela de Perfil (`profile/profile_screen.dart`):**
    * **Descrição:** Permite ao usuário visualizar e, possivelmente, editar suas informações pessoais e configurações da conta.
    * **Funcionalidades:** Exibição de dados do usuário, opções de configuração (ex: mudar senha, notificações).

6.  **Tela de Transferência (`transfer/transfer_screen.dart`):**
    * **Descrição:** Interface para o usuário realizar transferências de valores para outras contas dentro ou fora do TarsoBank.
    * **Funcionalidades:** Seleção de destinatário (digitação de CPF/CNPJ ou dados bancários), inserção do valor da transferência, confirmação.

7.  **Tela de Cotação (`quotation/quotation_screen.dart`):**
    * **Descrição:** Exibe cotações de moedas ou outros ativos financeiros em tempo real (ou próximo do real), obtidas através de uma API externa.
    * **Funcionalidades:** Lista de moedas e seus valores atualizados, possivelmente gráficos históricos.

## 🛠 Tecnologias Utilizadas

* **Flutter:** Framework de desenvolvimento de interface de usuário de código aberto do Google para criar aplicativos compilados nativamente para mobile (iOS e Android), web e desktop a partir de uma única base de código.
* **Dart:** Linguagem de programação otimizada para UI, desenvolvida pelo Google, utilizada pelo Flutter.
* **SQLite:** Banco de dados relacional leve e embutido, utilizado para armazenamento local de dados no aplicativo.
* **Provider:** (ou outro gerenciador de estado como GetX, BLoC, etc.) Para gerenciamento de estado na aplicação, garantindo uma arquitetura robusta e reativa. (Verifique o `pubspec.yaml` para o gerenciador de estado exato, caso não seja Provider).
* **HTTP:** Para comunicação com APIs externas.
* **SQFlite:** Plugin para Flutter que permite a interação com o banco de dados SQLite.
## Telas Principais

O aplicativo conta com as seguintes telas principais:

1.  **SplashScreen (`splash_screen.dart`):**
    * **Descrição:** Tela inicial exibida durante o carregamento do aplicativo, muitas vezes usada para carregar dados iniciais.
    * **Funcionalidades:** Apresentação da marca, transição para a tela de autenticação ou dashboard.

2.  **Tela de Login (`auth/login_screen.dart`):**
    * **Descrição:** Permite que usuários existentes acessem suas contas.
    * **Funcionalidades:** Campos para e-mail/usuário e senha, botão de login, navegação para a tela de cadastro.

3.  **Tela de Cadastro (`auth/register_screen.dart`):**
    * **Descrição:** Permite que novos usuários criem uma conta no TarsoBank.
    * **Funcionalidades:** Campos para informações pessoais e de login (nome, e-mail, senha), botão de registro.

4.  **Tela Inicial / Dashboard (`home/home_screen.dart` e `home/dashboard.dart`):**
    * **Descrição:** Tela principal após o login, exibindo um resumo das atividades financeiras, saldo, e acesso rápido a outras funcionalidades do banco.
    * **Funcionalidades:** Visualização de saldo, atalhos para transferências, extrato (se implementado), cotações de moedas.

5.  **Tela de Perfil (`profile/profile_screen.dart`):**
    * **Descrição:** Permite ao usuário visualizar e, possivelmente, editar suas informações pessoais e configurações da conta.
    * **Funcionalidades:** Exibição de dados do usuário, opções de configuração (ex: mudar senha, notificações).

6.  **Tela de Transferência (`transfer/transfer_screen.dart`):**
    * **Descrição:** Interface para o usuário realizar transferências de valores para outras contas dentro ou fora do TarsoBank.
    * **Funcionalidades:** Seleção de destinatário (digitação de CPF/CNPJ ou dados bancários), inserção do valor da transferência, confirmação.

7.  **Tela de Cotação (`quotation/quotation_screen.dart`):**
    * **Descrição:** Exibe cotações de moedas ou outros ativos financeiros em tempo real (ou próximo do real), obtidas através de uma API externa.
    * **Funcionalidades:** Lista de moedas e seus valores atualizados, possivelmente gráficos históricos.

---

## 🛠 Tecnologias Utilizadas

* **Flutter:** Framework de desenvolvimento de interface de usuário de código aberto do Google para criar aplicativos compilados nativamente para mobile (iOS e Android), web e desktop a partir de uma única base de código.
* **Dart:** Linguagem de programação otimizada para UI, desenvolvida pelo Google, utilizada pelo Flutter.
* **SQLite:** Banco de dados relacional leve e embutido, utilizado para armazenamento local de dados no aplicativo.
* **Provider:** (ou outro gerenciador de estado como GetX, BLoC, etc.) Para gerenciamento de estado na aplicação, garantindo uma arquitetura robusta e reativa.
* **HTTP:** Para comunicação com APIs externas.
* **SQFlite:** Plugin para Flutter que permite a interação com o banco de dados SQLite.
* **Outros pacotes:** Dependendo das funcionalidades implementadas (por exemplo, `intl` para formatação, `url_launcher` para abrir URLs externas, etc.).

---

## 🚀 Como Executar

Para rodar o projeto TarsoBank localmente, siga os passos abaixo:

1.  **Pré-requisitos:** Certifique-se de ter o Flutter SDK instalado e configurado em seu ambiente. Você pode seguir as instruções oficiais em [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).

2.  **Clone o repositório:** Abra seu terminal ou prompt de comando e execute:
    ```bash
    git clone [https://github.com/DavidSFreire/tarsobank.git](https://github.com/DavidSFreire/tarsobank.git)
    ```

3.  **Navegue até o diretório do projeto:**
    ```bash
    cd tarsobank
    ```

4.  **Instale as dependências:** Este comando baixa todos os pacotes e dependências listados no `pubspec.yaml`:
    ```bash
    flutter pub get
    ```
    
5.  **Execute o aplicativo:** Conecte um dispositivo Android ou iOS (ou inicie um emulador/simulador) ou execute em uma plataforma desktop/web.
    ```bash
    flutter run
    ```

    Se quiser executar em um dispositivo específico, use `flutter run -d <device_id>`. Para listar os IDs disponíveis, execute `flutter devices`.

---

## 📱 Download do APK

Você pode baixar a versão mais recente do aplicativo TarsoBank para Android diretamente no link abaixo:

* **[Download TarsoBank.apk](https://drive.google.com/file/d/1o4IVtlLugTFjXUbjpznFxf08fbrF4Mba/view?usp=sharing)**

---

## 🎨 Design no Figma

Explore o design e a prototipagem do TarsoBank diretamente no Figma:

* **[Link para o Projeto no Figma](https://www.figma.com/design/MmjAUlbslVrKKhTuulcvOG/App-banco-unama?node-id=0-1&p=f&t=6vNvjWo5Ry32niij-0)** 

---


## 🤝 Contribuições

Contribuições são extremamente bem-vindas! Se você tiver ideias para melhorias, encontrar bugs, ou quiser adicionar novas funcionalidades, sinta-se à vontade para:

1.  Abrir uma [Issue](https://github.com/DavidSFreire/tarsobank/issues) para discutir a mudança proposta.
2.  Realizar um `Fork` do projeto.
3.  Criar uma `Branch` para sua feature (`git checkout -b feature/sua-feature`).
4.  Fazer seus `Commits` (`git commit -m 'Adiciona nova feature X'`).
5.  Enviar suas mudanças para a `Branch` (`git push origin feature/sua-feature`).
6.  Abrir um [Pull Request](https://github.com/DavidSFreire/tarsobank/pulls).

---

## 🧑‍💻 Contribuidores

Um agradecimento especial a todos que contribuíram para o desenvolvimento deste projeto:

* **[David Freire](https://github.com/DavidSFreire)** - Desenvolvedor Principal

---