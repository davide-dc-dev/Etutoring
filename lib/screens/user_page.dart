import 'package:argon_flutter/widgets/button_widget.dart';
import 'package:argon_flutter/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/utils/user_secure_storage.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // For CircularProgressIndicator.
  bool visible = false;

  // Initially password is obscure
  bool _obscureText = true;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  /*DateTime birthday;
  List<String> pets = [];*/

  @override
  void initState() {
    super.initState();
    // init();
  }

// Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    /*final birthday = await UserSecureStorage.getBirthday() ?? '';
    final pets = await UserSecureStorage.getPets() ?? [];*/

    this.emailController.text = name;
    this.passwordController.text = password;
    /*this.birthday = birthday;
    this.pets = pets;*/
    /*setState(() {
      this.controllerName.text = name;
      this.controllerNamePwd.text = password;
      this.birthday = birthday;
      this.pets = pets;
    });*/
  }

  @override
  Widget build(BuildContext context) {
    this.setState(() {
      init();
    });
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TitleWidget(icon: Icons.login, text: 'Welcome to\nE-tutoring'),
            const SizedBox(height: 32),
            buildName(),
            const SizedBox(height: 12),
            buildPassword(),
            const SizedBox(height: 12),
            /*buildBirthday(),
            const SizedBox(height: 12),
            buildPets(),
            const SizedBox(height: 32),*/
            buildButton(),
            Visibility(
              visible: false,
              child: Center(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
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

  /*Widget buildBirthday() => buildTitle(
        title: 'Birthday',
        child: BirthdayWidget(
          birthday: birthday,
          onChangedBirthday: (birthday) =>
              setState(() => this.birthday = birthday),
        ),
      );

  Widget buildPets() => buildTitle(
        title: 'Pets',
        child: PetsButtonsWidget(
          pets: pets,
          onSelectedPet: (pet) => setState(
              () => pets.contains(pet) ? pets.remove(pet) : pets.add(pet)),
        ),
      );*/

  Widget buildButton() => ButtonWidget(
      text: 'Login',
      onClicked: () async {
        if (formKey.currentState.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          await UserSecureStorage.setUsername(emailController.text);
          await UserSecureStorage.setPassword(passwordController.text);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login and Save Data')));
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
