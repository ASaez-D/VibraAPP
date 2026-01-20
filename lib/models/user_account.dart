class UserAccount {
  final String displayName;
  final String email;
  final String? imageUrl;
  final String? profileUrl;

  UserAccount.fromMap(Map<String, dynamic> map)
      : displayName = map['displayName'] ?? 'Usuario Vibra',
        email = map['email'] ?? 'correo@oculto.com',
        imageUrl = map['photoURL'],
        profileUrl = map['profileUrl'];
}