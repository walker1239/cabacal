import 'package:caba_cal/bloc_users/models/_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_formfield/flutter_datetime_formfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../bloc_users/blocs.dart';
import '../bloc_users/services/authentication_service.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        //height: MediaQuery.of(context).size.height,
        //width: MediaQuery.of(context).size.width,
        child: Center(
          child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authBloc, authService),
            child:_SignInForm1(),
          ),
        ),
      ),
    );
  }
}

class _SignInForm1 extends StatefulWidget {
  @override
  __SignInForm1State createState() => __SignInForm1State();
}

class __SignInForm1State extends State<_SignInForm1> {

  //final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final userName = TextEditingController();
  final motherSurname = TextEditingController();
  final fatherSurname = TextEditingController();
  final gender = TextEditingController();
  DateTime birth;
  final weight = TextEditingController();
  final tall = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  //bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onRegisterButtonPressed () {
      String dateSlug ="${birth.year.toString()}-${birth.month.toString().padLeft(2,'0')}-${birth.day.toString().padLeft(2,'0')}";
      User temp= new User(id:1,userName:userName.text,motherSurname:motherSurname.text,fatherSurname:fatherSurname.text,gender:gender.text,weight:weight.text,tall:tall.text,email:email.text,password: password.text,birth: dateSlug);
      _loginBloc.add(RegisterButtonPressed(
        user:temp,
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
                    top: 35,
                    right: 20.0,
                    left: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height*.90,
                  width: MediaQuery.of(context).size.width*.90,
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
                                controller: email,
                                autocorrect: false,
                                validator: (value){
                                  if (value == null){
                                    return 'El usuario es necesario.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 10),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                obscureText: true,
                                controller: password,
                                validator: (value) {
                                  if (value == null){
                                    return 'La Contraseña es requerida.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 10),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: userName,
                                validator: (value) {
                                  if (value == null){
                                    return 'El nombre es requerido.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 10),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Apellido del Padre',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: fatherSurname,
                                validator: (value) {
                                  if (value == null){
                                    return 'El apellido es requerido.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 25),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Apellido de la Madre',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: motherSurname,
                                validator: (value) {
                                  if (value == null){
                                    return 'El apellido es requerido.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 25),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Peso',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: weight,
                                validator: (value) {
                                  if (value == null){
                                    return 'El peso es requerido.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 25),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Talla',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: tall,
                                validator: (value) {
                                  if (value == null){
                                    return 'La talla es requerida.';
                                  }
                                  return null;
                                },
                              ),
                              
                              Padding(padding: EdgeInsets.only(top: 25),),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Genero',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                controller: gender,
                                validator: (value) {
                                  if (value == null){
                                    return 'El genero es requerido.';
                                  }
                                  return null;
                                },
                              ),
                              Padding(padding: EdgeInsets.only(top: 40),),
                              DateTimeFormField(
                                initialValue: birth,
                                //formatter: DateFormat('yyyy-mm-dd'),
                                label: "Cumpleaños",
                                validator: (DateTime dateTime) {
                                  if (dateTime == null) {
                                    return "Date Time Required";
                                  }
                                  return null;
                                },
                                onSaved: (DateTime dateTime) => birth = dateTime,
                              ),
                              Center(child:
                                RaisedButton(
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.only(left:50,right:50,top: 15,bottom: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Text('Iniciar Sesión'),
                                  onPressed: state is LoginLoading ? () {} : _onRegisterButtonPressed,
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
