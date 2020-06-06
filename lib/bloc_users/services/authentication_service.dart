import '../exceptions/authentication_exception.dart';
import '../models/_user.dart';
import '../../db/db_user.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationService {
  Future<User> getCurrentUser();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> register(User user);
  Future<void> signOut();
}

class FakeAuthenticationService extends AuthenticationService {
  @override
  Future<User> getCurrentUser() async {
    User temp= await DbUser.db.getUser();
    return temp; // return null for now
  }
  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
  User temp= new User(id:1,userName:"walker",motherSurname:"chalco",fatherSurname:"manrique",gender:"masculino",weight:"80",tall:"1.78",email:"wlke",password: "123",birth:"2001-06-08");
  return temp;
    /*final response = await http
        .post("https://boringo.000webhostapp.com/flutter/get_user.php", body: {
          'user': email.toLowerCase(),
          'password': password,
        });
    print(email+' '+password);
    print(response.body.toString());
    if(response.body=="ERROR"){
      throw AuthenticationException(message: 'Usuario o contraseña incorrecta');
    }
    else{
      User temp=userFromJson(response.body);
      return temp;
    }*/
  }
  Future<User> register(User user) async {
    User temp= await DbUser.db.newUser(user);
    return temp;
    /*final response = await http
        .post("https://boringo.000webhostapp.com/flutter/get_user.php", body: {
          'user': email.toLowerCase(),
          'password': password,
        });
    print(email+' '+password);
    print(response.body.toString());
    if(response.body=="ERROR"){
      throw AuthenticationException(message: 'Usuario o contraseña incorrecta');
    }
    else{
      User temp=userFromJson(response.body);
      return temp;
    }*/
  }

  @override
  Future<void> signOut() async {
    await DbUser.db.deleteUser();
    return null;
  }
}