import 'package:argon_flutter/config/config.dart';
import 'package:argon_flutter/widgets/button_widget.dart';
import 'package:argon_flutter/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/utils/user_secure_storage.dart';

import 'package:argon_flutter/screens/profileUser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // For CircularProgressIndicator.
  bool visible = false;

  // Initially password is obscure
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

// Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future userLogin() async {
    setState(() {
      // Showing CircularProgressIndicator.
      visible = true;
    });

    try {
      // Getting value from Controller
      String email = emailController.text;
      String password = passwordController.text;
      // Store all data with Param Name.
      var data = {'email': email, 'password': password};

      // Starting Web API Call.
      var response = await http
          .post(Uri.http(authority, unencodedPath + 'user_login.php'),
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      switch (response.statusCode) {
        case 200:
          // Getting Server response into variable.
          var message = jsonDecode(response.body);

          // If the Response Message is Matched.
          if (message == 'Login Matched') {
            // Hiding the CircularProgressIndicator.

            setState(() {
              visible = false;
            });

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          } else {
            UserSecureStorage.delete('email');
            UserSecureStorage.delete('password');

            // If Email or Password did not Matched.
            // Hiding the CircularProgressIndicator.
            setState(() {
              visible = false;
            });

            // Showing Alert Dialog with Response JSON Message.
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text(message),
                  actions: <Widget>[
                    TextButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          break;
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Error. Verify Your Connection.'),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        visible = false;
      });
    }
  }

  Future init() async {
    final email = await UserSecureStorage.getEmail() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';

    this.emailController.text = email;
    this.passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      init();
    });
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 50),
            Image.asset('assets/img/logo_size.jpg', height: 100, width: 100),
            TitleWidget(icon: Icons.login, text: 'Welcome to\nE-tutoring'),
            const SizedBox(height: 32),
            buildName(),
            const SizedBox(height: 12),
            buildPassword(),
            const SizedBox(height: 50),
            buildButton(),
            const SizedBox(height: 50),
            Visibility(
              visible: visible,
              child: Center(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Widget buildName() => buildTitle(
        title: 'E-mail',
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          controller: emailController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: 'Your Email',
              prefixIcon: Icon(Icons.email)),
        ),
      );

  Widget buildPassword() => buildTitle(
        title: 'Password',
        child: TextFormField(
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          controller: passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: 'Your Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                _toggle();
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );

  Widget buildButton() => ButtonWidget(
      text: 'Login',
      onClicked: () async {
        if (formKey.currentState.validate()) {
          await UserSecureStorage.setEmail(emailController.text);
          await UserSecureStorage.setPassword(passwordController.text);
          userLogin();
        }

        /*await UserSecureStorage.setPets(pets);

        if (birthday != null) {
          await UserSecureStorage.setBirthday(birthday);
        }*/
      });

  Widget buildTitle({
    String title,
    Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}