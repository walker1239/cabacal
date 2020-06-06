import 'dart:convert';

import 'dart:ffi';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
//names, father_surname, mother_surname, gender, birth, weight, tall, email, password
class User {
  int id;
  String userName;
  String motherSurname;
  String fatherSurname;
  String gender;
  String birth;
  String weight;
  String tall;
  String email;
  String password;



  User({
    this.id,
    this.userName,
    this.motherSurname,
    this.fatherSurname,
    this.gender,
    this.birth,
    this.weight,
    this.tall,
    this.email,
    this.password,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id:1,
    userName: json["userName"],
    motherSurname: json["motherSurname"],
    fatherSurname: json["fatherSurname"],
    gender: json["gender"],
    birth: json["birth"],
    weight: json["weight"],
    tall: json["tall"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userName": userName,
    "motherSurname": motherSurname,
    "fatherSurname": fatherSurname,
    "gender": gender,
    "birth": birth,
    "weight": weight,
    "tall": tall,
    "email": email,
    "password": password,
  };

  int get _id=>id;
  String get _userName=>userName;
  String get _motherSurname=>motherSurname;
  String get _fatherSurname=>fatherSurname;
  String get _gender=>gender;
  String get _birth=>birth;
  String get _weight=>weight;
  String get _tall=>tall;
  String get _email=>email;
  String get _password=>password;

}