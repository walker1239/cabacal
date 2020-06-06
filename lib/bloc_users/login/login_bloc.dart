import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication.dart';
import '../exceptions/authentication_exception.dart';
import '../services/authentication_service.dart';
import '../models/_user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc, AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    print('loginblocmapEventToState ->');
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    }
    if (event is RegisterButtonPressed) {
      yield* register(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(LoginInWithEmailButtonPressed event) async* {
    yield LoginLoading();
    try {
      User user = await _authenticationService.signInWithEmailAndPassword(event.email, event.password);
      //print('loginbloc ->'+ user.userName + 'email'+event.email);
      if (user != null){
        // push new authentication event
        _authenticationBloc.add(UserLoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      }else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on AuthenticationException catch(e){
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }
  Stream<LoginState> register(RegisterButtonPressed event) async* {
    yield LoginLoading();
    try {
      User user = await _authenticationService.register(event.user);
      if (user != null){
        // push new authentication event
        _authenticationBloc.add(UserLoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      }else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on AuthenticationException catch(e){
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
