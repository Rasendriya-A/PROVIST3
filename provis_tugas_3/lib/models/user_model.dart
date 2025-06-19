class UserModel {
  final String uid; // Changed from id to uid to match Firebase Auth
  final String name;
  final String email;
  final String? photoURL; // Added for user image

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoURL': photoURL,
    };
  }
}
