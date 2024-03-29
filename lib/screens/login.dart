import 'package:e_tutoring/config/config.dart';
import 'package:e_tutoring/constants/Theme.dart';
import 'package:e_tutoring/controller/controllerWS.dart';
import 'package:e_tutoring/screens/signup.dart';
import 'package:e_tutoring/widgets/button_widget.dart';
import 'package:e_tutoring/widgets/title_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:e_tutoring/utils/user_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // CONTROLLER
  Future userLogin() async {
    setState(() {
      // Showing CircularProgressIndicator.
      visible = true;
    });

    try {
      // Getting value from Controller
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      // Store all data with Param Name: json format
      var data = {'email': email, 'password': password};

      // Starting Web API Call.
      // https method: POST
      var response = await http
          .post(Uri.https(authority, unencodedPath + 'user_login.php'),
              headers: <String, String>{'authorization': basicAuth},
              body: json.encode(data))
          .timeout(const Duration(seconds: 8));
      // print(response.body);
      switch (response.statusCode) {
        case 200:
          // Getting Server response into variable.
          var message = jsonDecode(response.body);

          // If the Response Message is Matched.
          if (message == 'Login Matched') {
            await UserSecureStorage.setEmail(emailController.text);
            await UserSecureStorage.setPassword(passwordController.text);

            // get user role
            dynamic role =
                await getRoleFromWS(http.Client(), emailController.text);
            await UserSecureStorage.setRole(role.role_name);

            // UserSecureStorage.getRole().then((value) => print(value));

            // Hiding the CircularProgressIndicator.
            //print(emailController.text);
            //print(passwordController.text);
            setState(() {
              visible = false;
            });

            Navigator.pushNamed(context, "/profile");
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

  // VIEW
  @override
  Widget build(BuildContext context) {
    this.setState(() {
      // init();
    });
    return new WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text("E-Tutoring " + AppLocalizations.of(context).login),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1),
            // actions: [LanguagePickerWidget()],
          ),
          backgroundColor: Colors.white,
          body: Scaffold(
              // resizeToAvoidBottomInset: false,
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
                  text: AppLocalizations.of(context).welcome,
                  color: ArgonColors.redUnito,
                  fontSize: 36,
                ),
                const SizedBox(height: 32),
                buildEmail(),
                const SizedBox(height: 12),
                buildPassword(),
                const SizedBox(height: 50),
                buildLoginButton(),
                const SizedBox(height: 50),
                builRegisteredButton(),
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
              ],
            ),
          )),
        ));
  }

  Widget buildEmail() => buildTitle(
        title: 'E-mail',
        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).error_email_empty;
            }
            if (!EmailValidator.validate(value)) {
              return AppLocalizations.of(context).error_email_not_valid;
            }
            return null;
          },
          controller: emailController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              hintText: AppLocalizations.of(context).youremail,
              prefixIcon: Icon(Icons.email)),
        ),
      );

  Widget buildPassword() => buildTitle(
        title: 'Password',
        child: TextFormField(
          obscureText: _obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).error_password_empty;
            }
            return null;
          },
          controller: passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: AppLocalizations.of(context).yourpassword,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () async {
                print(this.emailController.text);
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

  Widget buildLoginButton() => ButtonWidget(
      pressed: true,
      text: AppLocalizations.of(context).login,
      color: ArgonColors.redUnito,
      onClicked: () async {
        if (formKey.currentState.validate()) {
          userLogin();
        }
      });

  Widget builRegisteredButton() => ButtonWidget(
      pressed: true,
      text: AppLocalizations.of(context).signup,
      color: ArgonColors.blueUnito,
      onClicked: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signup()));
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
