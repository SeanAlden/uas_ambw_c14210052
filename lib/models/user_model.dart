class UserModel {
  final String id;
  final String authId;
  final String username;
  final String phoneNumber;
  final String email;
  final DateTime createdAt;
  final String? avatarPath;

  UserModel({
    required this.id,
    required this.authId,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    this.avatarPath,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as String,
        authId: map['auth_id'] as String,
        username: map['username'] as String,
        phoneNumber: map['phone_number'] as String,
        email: map['email'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        avatarPath: map['avatar_path']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auth_id': authId,
      'username': username,
      'phone_number': phoneNumber,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'avatar_path': avatarPath
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, authId: $authId, username: $username, phoneNumber: $phoneNumber, email: $email, createdAt: $createdAt, avatarPath: $avatarPath)';
  }
}

extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    String? id,
    String? authId,
    String? username,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
    String? avatarPath,
  }) {
    return UserModel(
      id: id ?? this.id,
      authId: authId ?? this.authId,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
