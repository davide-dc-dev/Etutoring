import 'dart:ui';
import 'package:argon_flutter/config/config.dart';
import 'package:argon_flutter/widgets/button_widget.dart';
import 'package:argon_flutter/widgets/title_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:argon_flutter/constants/Theme.dart';

//widgets
import 'package:argon_flutter/widgets/input.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _checkboxValue = false;

  final double height = window.physicalSize.height;

  // For CircularProgressIndicator.
  bool visible = false;

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  // CONTROLLER
  Future userSignin() async {
    setState(() {
      // Showing CircularProgressIndicator.
      visible = true;
    });

    try {
      // Getting value from Controller
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String firstname = firstnameController.text.trim();
      String lastname = lastnameController.text.trim();
      // Store all data with Param Name: json format
      var data = {
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname
      };

      // Starting Web API Call.
      // http method: POST
      var response = await http
          .post(Uri.http(authority, unencodedPath + 'user_signin.php'),
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      print(response.body);
      /*switch (response.statusCode) {
        case 200:
          // Getting Server response into variable.
          var message = jsonDecode(response.body);

          // If the Response Message is Matched.
          if (message == 'Login Matched') {
            await UserSecureStorage.setEmail(emailController.text);
            await UserSecureStorage.setPassword(passwordController.text);
            // Hiding the CircularProgressIndicator.
            //print(emailController.text);
            //print(passwordController.text);
            setState(() {
              visible = false;
            });

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Profile()));
          } else {
            // UserSecureStorage.delete('email');
            //  UserSecureStorage.delete('password');

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
                        this.emailController.text = email;
                        this.passwordController.text = password;
                      },
                    ),
                  ],
                );
              },
            );
          }
          break;
      }*/
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Sign In'),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(205, 205, 205, 1))),
            SafeArea(
              child: Scaffold(
                body: Form(
                  key: formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 10),
                      Image.asset('assets/img/logo_size_2.jpg',
                          height: 100, width: 100),
                      TitleWidget(
                        icon: Icons.login,
                        text: 'Sign In',
                        color: ArgonColors.redUnito,
                        fontSize: 36,
                      ),
                      const SizedBox(height: 32),
                      buildEmail(),
                      const SizedBox(height: 12),
                      buildPassword(),
                      const SizedBox(height: 12),
                      buildFistname(),
                      const SizedBox(height: 12),
                      buildLastname(),
                      const SizedBox(height: 30),
                      buildSignInButton(),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: visible,
                        child: Center(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                child: CircularProgressIndicator(
                                  backgroundColor: ArgonColors.redUnito,
                                ))),
                      )
                      /*Container(
                                  /*height:
                                      MediaQuery.of(context).size.height * 0.63,*/
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [*/
                      /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Input(
                              controller: emailController,
                              placeholder: "Your Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),*/
                      /* Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Input(
                                controller: passwordController,
                                placeholder: "Your Password",
                                prefixIcon: Icon(Icons.lock)),
                          ),*/
                      /*Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0),
                                            child: RichText(
                                                text: TextSpan(
                                                    text: "password strength: ",
                                                    style: TextStyle(
                                                        color:
                                                            ArgonColors.muted),
                                                    children: [
                                                  TextSpan(
                                                      text: "strong",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: ArgonColors
                                                              .success))
                                                ])),
                                          ),*/
                      /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Input(
                                controller: firstnameController,
                                placeholder: "Yout Firstname",
                                prefixIcon: Icon(Icons.person)),
                          ),*/
                      /* Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Input(
                                controller: lastnameController,
                                placeholder: "Your Lastname",
                                prefixIcon: Icon(Icons.person)),
                          ),*/
                      // ],
                      // ),
                      /* Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 0, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: ArgonColors.primary,
                                    onChanged: (bool newValue) => setState(
                                        () => _checkboxValue = newValue),
                                    value: _checkboxValue),
                                Text("I agree with the",
                                    style: TextStyle(
                                        color: ArgonColors.muted,
                                        fontWeight: FontWeight.w200)),
                                GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text("Privacy Policy",
                                          style: TextStyle(
                                              color: ArgonColors.primary)),
                                    )),
                              ],
                            ),
                          ),*/
                      /* ButtonWidget(
                              text: 'Sign In',
                              color: ArgonColors.redUnito,
                              onClicked: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Sign In'),
                                          content: const Text(
                                              'User sign in with succes/failure'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'OK');
                                                Navigator.pushNamed(
                                                    context, '/login');
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              }),*/
                    ],
                  ),
                ),
                /*))
                            ],*/
              ) /*))*/,
              /*),
              ]),*/
            )
          ],
        ));
  }

  Widget buildEmail() => buildTitle(
        title: 'E-mail',
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email';
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

  Widget buildFistname() => buildTitle(
        title: 'Firstname',
        child: TextFormField(
          validator: (value) {
            return null;
          },
          controller: firstnameController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: 'Your Firstname',
              prefixIcon: Icon(Icons.person)),
        ),
      );

  Widget buildLastname() => buildTitle(
        title: 'Lastname',
        child: TextFormField(
          validator: (value) {
            return null;
          },
          controller: lastnameController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: 'Your Lastname',
              prefixIcon: Icon(Icons.person)),
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
              onTap: () async {
                print(this.emailController.text);
                /*await UserSecureStorage.setEmail(emailController.text);
                await UserSecureStorage.setPassword(passwordController.text);*/
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

  Widget buildSignInButton() => ButtonWidget(
      text: 'Sign In',
      color: ArgonColors.redUnito,
      onClicked: () {
        if (formKey.currentState.validate()) {
          userSignin();

          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Sign In'),
                    content: const Text('User sign in with succes/failure'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        }
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
