import 'package:flutter/material.dart';

import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/views/admin_page_view.dart';
import 'package:product_view_app/presentation/views/home_page_view.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginController loginController = LoginController();
  bool isActiveLoginFail = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.sizeOf(context).width / 2;

    Future<bool> onLogin(
        {required String username, required String password}) async {
      if (username == "" || password == "") {
        return false;
      }
      await loginController.login(username, password);
      if (loginController.modelData.status != 200) {
        return false;
      }

      return true;
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
                  child: Text(
                    isActiveLoginFail
                        ? "Username or password is incorrect!!!"
                        : "",
                    style: const TextStyle(
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
                    onPressed: () async {
                      await onLogin(
                              password: passwordController.text,
                              username: nameController.text)
                          .then(
                        (isSuccess) => {
                          if (isSuccess)
                            {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      loginController.modelData.isAdmin
                                          ? const AdminPageView()
                                          : const HomePageView(),
                                ),
                              )
                            }
                          else
                            {
                              setState(() {
                                isActiveLoginFail = true;
                              })
                            }
                        },
                      );
                    },
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
