import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'bloc_users/blocs.dart';
import 'bloc_users/services/authentication_service.dart';
import 'pages/pages.dart';

void main() => runApp(
  // Injects the Authentication service
  RepositoryProvider<AuthenticationService>(
    create: (context) {
      return FakeAuthenticationService();
    },
    // Injects the Authentication BLoC
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        final authService = RepositoryProvider.of<AuthenticationService>(context);
        return AuthenticationBloc(authService)..add(AppLoaded());
      },
      child: MyApp(),
    ),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servicios Motta',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      // BlocBuilder will listen to changes in AuthenticationState
      // and build an appropriate widget based on the state.
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page
            return Home(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}
