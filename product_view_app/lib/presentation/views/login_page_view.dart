import 'package:flutter/material.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width / 2;

    void onLogin({required String username, required String password}) {
      print(username + " ---------- " + password);
    }

    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Product Views Application",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  width: sizeWidth,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.info_outline, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                      hintText: ' Enter username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24.0),
                  width: sizeWidth,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.verified_user_outlined,
                          color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                      ),
                      hintText: ' Enter password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: const Text(
                    "Username or password is incorrect!!!",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: sizeWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => onLogin(
                        password: passwordController.text,
                        username: nameController.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
