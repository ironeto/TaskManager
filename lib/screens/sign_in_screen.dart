import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/weather_forecast.dart';
import '../routes/route_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, this.onSignedIn, FirebaseAuth? auth})
      : auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  final VoidCallback? onSignedIn;
  final FirebaseAuth auth;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController =
      TextEditingController(text: 'ironeto@hotmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'teste@12');
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    try {
      final user = await widget.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (widget.onSignedIn != null) widget.onSignedIn!();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuário autenticado."),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushReplacementNamed(RoutePaths.TASKS_LIST_SCREEN);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Falha ao autenticar"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.assignment),
            SizedBox(width: 10),
            Text(
              'Gerenciador de Tarefas',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const Key("emailField"),
                      controller: emailController,
                      decoration: const InputDecoration(labelText: "e-mail"),
                    ),
                    TextField(
                      key: const Key("passwordField"),
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "senha"),
                    ),
                    isLoading
                        ? Align(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator())
                        : Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              key: const Key("loginButton"),
                              onPressed: login,
                              child: const Text("Login"),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          WeatherForecastComponent(),
        ],
      ),
    );
  }
}
