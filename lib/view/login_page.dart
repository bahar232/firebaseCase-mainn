import 'package:bahar_firebase_case/service/auth_service.dart';
import 'package:bahar_firebase_case/view/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  AuthService authService = AuthService();

  void clear() {
    emailController.text = "";
    passController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
              )),
          Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: passController,
                decoration: InputDecoration(hintText: "Password"),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    authService.signIn(
                        emailController.text, int.parse(passController.text));

                    clear();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text("Giriş")),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              ElevatedButton(
                  onPressed: () {
                    authService.signUp(
                        emailController.text, int.parse(passController.text));
                    clear();
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("")));
                  },
                  child: Text("Kayıt Ol")),
            ],
          ),
        ],
      ),
    );
  }
}
