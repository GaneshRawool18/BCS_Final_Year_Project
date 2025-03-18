class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobile;

  UserModel({required this.uid, required this.name, required this.email, required this.mobile});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}
