import 'package:caba_cal/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc_users/blocs.dart';
import '../bloc_users/services/authentication_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        //height: MediaQuery.of(context).size.height,
        //width: MediaQuery.of(context).size.width,
        child: Center(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state){
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              if (state is AuthenticationNotAuthenticated){
                return _AuthForm(); // show authentication form
              }
              if (state is AuthenticationFailure) {
                // show error message
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(state.message),
                        FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text('Retry'),
                          onPressed: () {
                            authBloc.add(AppLoaded());
                          },
                        )
                      ],
                    ));
              }
              // show splash screen
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          )
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Container(
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child:_SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {

  //final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  //bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed () {
      _loginBloc.add(LoginInWithEmailButtonPressed(
        email: emailController.text,
        password: passwordController.text
      ));
    }
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state){
        if (state is LoginFailure){
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state){
          if (state is LoginLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: <Widget>[
              // The containers in the background
              Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[100], Colors.lightBlue]
                      )
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .75,
                    color: Colors.white,
                  )
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .13,
                    right: 20.0,
                    left: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height*.75,
                  width: MediaQuery.of(context).size.width*.80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color:Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        //Image.asset("assets/LOGO.png",scale: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 5, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: emailController,
                                autocorrect: false,
                                validator: (value){
                                  if (value == null){
                                    return 'El usuario es necesario.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 25),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                obscureText: true,
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null){
                                    return 'La Contraseña es requerida.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 40),),
                              Center(child:
                                RaisedButton(
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.only(left:50,right:50,top: 15,bottom: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Text('Iniciar Sesión'),
                                  onPressed: state is LoginLoading ? () {} : _onLoginButtonPressed,
                                ),
                              ),
                              Center(child:
                                RaisedButton(
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.only(left:65,right:65,top: 15,bottom: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Text('Registrar'),
                                  onPressed:(){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterPage()),
                                    );
                                  },
                                ),
                              )
                            ]
                          )
                        ),
                      ],
                    ),
                    elevation: 0.0,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).errorColor,
      )
    );
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

}
