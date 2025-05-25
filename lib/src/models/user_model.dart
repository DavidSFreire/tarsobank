class User {
  int? id;
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String accountNumber;
  final String agency;

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
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, cpf: $cpf, email: $email, account: $accountNumber, agency: $agency)';
  }
}