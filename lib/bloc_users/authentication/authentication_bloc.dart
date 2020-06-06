import 'package:bloc/bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';
import '../services/authentication_service.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService;

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      print('mapEventToState AppLoaded');
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      print('mapEventToState UserLoggedIn');
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      print('mapEventToState UserLoggedOut');
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading(); // to display splash screen
    try {
      await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
      final currentUser = await _authenticationService.getCurrentUser();

      if (currentUser != null) {
        print('_mapAppLoadedToState'+currentUser.userName);
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        print('_mapAppLoadedToState null');
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.message ?? 'An unknown error occurred');
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    print('_mapUserLoggedInToState'+event.user.userName);
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    print('_mapUserLoggedOutToState null');
    await _authenticationService.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
