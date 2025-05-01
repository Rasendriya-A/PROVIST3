class UserModel {
  final int id;
  final String name;
  final String email;
  String password; // Tetap menggunakan 'String', tanpa 'final'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Method untuk memperbarui password
  void updatePassword(String newPassword) {
    this.password = newPassword;
  }

  // Method konversi ke JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
