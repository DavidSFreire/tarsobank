class User {
  final int? id;
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String accountNumber;
  final String agency;
  final double balance; // Campo final, será inicializado pelo construtor

  User({
    this.id,
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.address,
    required this.password,
    required this.accountNumber,
    required this.agency,
    this.balance =
        1000.0, // Saldo padrão para novos usuários, se não especificado
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'phone': phone,
      'email': email,
      'address': address,
      'password': password,
      'accountNumber': accountNumber,
      'agency': agency,
      'balance': balance,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      password: map['password'],
      accountNumber: map['accountNumber'],
      agency: map['agency'],
      balance: (map['balance'] as num?)?.toDouble() ?? 1000.0,
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? cpf,
    String? phone,
    String? email,
    String? address,
    String? password,
    String? accountNumber,
    String? agency,
    double? balance,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      password: password ?? this.password,
      accountNumber: accountNumber ?? this.accountNumber,
      agency: agency ?? this.agency,
      balance: balance ?? this.balance,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, cpf: $cpf, email: $email, account: $accountNumber, agency: $agency, balance: $balance)';
  }
}
