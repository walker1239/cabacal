import 'package:caba_cal/bloc_users/models/_user.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithEmailButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginInWithEmailButtonPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
class RegisterButtonPressed extends LoginEvent {
  final User user;

  RegisterButtonPressed({@required this.user});

  @override
  List<Object> get props => [user];
}
