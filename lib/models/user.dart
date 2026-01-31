class User {
  final int id;
  final String phone;
  final String name;
  final String email;
  final String address;
  final String? accountNumber;
  
  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.email,
    required this.address,
    this.accountNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'address': address,
      'accountNumber': accountNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      phone: map['phone'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      accountNumber: map['accountNumber'],
    );
  }
}