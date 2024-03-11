class UserModel {
  String name;
  String email;
  String password;
  String createdAt;
  String uid;
  String profilepic;
  double totaleamount;
  double totalincome;
  double totalexpense;
  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.uid,
    required this.profilepic,
    required this.totalincome,
    required this.totalexpense,
    required this.totaleamount,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      uid: map['uid'] ?? "",
      createdAt: map['createdAt'] ?? "",
      totalincome: map['totalincome'] ?? "",
      totalexpense: map['totalxpense'] ?? "",
      totaleamount: map['totaleamount'] ?? "",
      profilepic: map['profilepic'] ?? '',
    );
  }
  Map<String, dynamic> tomap() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "uid": uid,
      'profilepic': profilepic,
      "createdAt": createdAt,
      'totaleamount': totaleamount,
      "totalincome": totalincome,
      "totalexpenses": totalexpense,
    };
  }
}
