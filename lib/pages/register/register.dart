import 'package:flutter/material.dart';
import 'package:project/db/sqlite_service.dart';
import 'package:project/pages/home/home.dart';
import 'package:project/models/user.dart';
import 'package:project/pages/login/login.dart';
import 'package:project/widgets/navbar_init.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project/service/http/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // text controllers
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late Future reg;
  bool checkbox = false;

  void saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          NavBar(),
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: firstnameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Firstname"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your firstname';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: lastnameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Lastname"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your lastname';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: companyController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Company"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: positionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Position"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your position';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter again your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'By selecting "Register", you are confirming that you have read and agree the Privacy Policy.',
                          style: TextStyle(
                              fontSize: 17.0, color: Colors.grey.shade700),
                        ), //Text
                        SizedBox(width: 10),
                        Checkbox(
                          value: checkbox,
                          onChanged: (value) {
                            setState(() {
                              checkbox = value!;
                              print(checkbox);
                            });
                          },
                        ), //Checkbox
                      ], //<Widget>[]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text ==
                                confirmPasswordController.text) {
                              if (checkbox) {
                                try {
                                  User user = User(
                                      firstnameController.text,
                                      lastnameController.text,
                                      emailController.text,
                                      companyController.text,
                                      positionController.text,
                                      passwordController.text);
                                  reg = register(user);
                                  await reg.then((value) {
                                    saveCredentials(emailController.text,
                                        passwordController.text);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home()));
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'There was a problem adding a user, please try again')),
                                  );
                                }
                              } else {
                                firstnameController.text = '';
                                lastnameController.text = '';
                                emailController.text = '';
                                companyController.text = '';
                                positionController.text = '';
                                passwordController.text = '';
                                confirmPasswordController.text = '';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'To register, you need to accept the Privacy Policy')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Passwords does not match')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill input')),
                            );
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
