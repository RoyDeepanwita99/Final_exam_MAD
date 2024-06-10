import 'dart:convert';
import 'dart:developer';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/model/LoginUser.dart';

import 'package:http/http.dart ' as http;
import 'package:localstorage/localstorage.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  late String username = ' ';
  late String email = '';

  late String password = '';
  late String userNameError = '';

  Future<void> handleLoginPress() async {
    print(email);
    print(password);
    if (!EmailValidator.validate(email)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Warning!!!!!"),
              icon: Icon(Icons.warning),
              content: Container(
                child: Text(" Invalid email. Please enter a vaalid email"),
              ),
            );
          });
      return;
    }

    Uri uri = Uri.parse(
        'https://task-management-backend-vhcq.onrender.com/api/v1/login');

    var payload = {
      "email": email,
      "password": password,
    };
    http.Response response = await http.post(uri, body: payload);

    print(" ${response.statusCode}");
    print(" ${response.body}"); //body
    dynamic decoded = json.decode(response.body); // map

    //print("$decoded{token}");

    LoginUser loginUser = LoginUser.fromJson(decoded['data']);
    // print(loginUser.email);
    // print(loginUser.firstName);
    // print(loginUser.lastName);

    print("$decoded{token}");

    localStorage.setItem('access-token', decoded['token']);
    Navigator.of(context).pushNamed('/Home');
    // print(email);
    // print(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black12,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Welcome",
              style: TextStyle(fontSize: 35),
            ),
            // TextFormField(
            //   style: TextStyle(fontSize: 16),
            //   onChanged: (value) {
            //     print('user name :$value');
            //     setState(() {
            //       username = value;
            //       if (value.contains('@')) {
            //         userNameError = 'Dont use @';
            //       } else {
            //         userNameError = '';
            //       }
            //     });
            //   },
            //   validator: (value) {
            //     return value != null && value.contains('@')
            //         ? 'Dont use @'
            //         : null;
            //   },
            //   decoration: InputDecoration(
            //       label: Text("User Name"),
            //       icon: Icon(Icons.people),
            //       hintText: "Enter user name",
            //       hintStyle: TextStyle(color: Colors.grey),
            //       errorText: userNameError.isEmpty ? null : userNameError),
            // ),
            TextFormField(
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  print('Email: $value');
                  setState(() {
                    email = value;
                  });
                },
                decoration: InputDecoration(
                    label: Text('Email'),
                    icon: Icon(Icons.email),
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    errorText: userNameError.isEmpty ? null : userNameError)),
            TextFormField(
              style: const TextStyle(fontSize: 16),
              onChanged: (value) {
                print('user name :$value');
                setState(() {
                  password = value;
                  if (value.contains('@')) {
                    userNameError = 'Dont use @';
                  } else {
                    userNameError = '';
                  }
                });
              },
              validator: (value) {
                return value != null && value.contains('@')
                    ? 'Dont use @'
                    : null;
              },
              decoration: InputDecoration(
                  label: Text("Password"),
                  icon: Icon(Icons.key_off),
                  hintText: "Enter password",
                  hintStyle: TextStyle(color: Colors.grey),
                  errorText: userNameError.isEmpty ? null : userNameError),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                handleLoginPress();
//////////////////////////////////////////
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: Text("Warning!!!!!"),
                //         icon: Icon(Icons.warning),
                //         content: Container(
                //           child: Text(
                //               " Invalid Credentists. please check your email or paassword"),
                //         ),
                //       );
                //     });

//////////////////////////////////////////////
              },
              child: Text("Login"),
            ),

            SizedBox(
              height: 30,
            ),

            Text("don't Have an Account?"),
            ElevatedButton(
              onPressed: () {
                // aro ache
                Navigator.of(context).pop();
              },
              child: Text("Try Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget getInputRow({String? label, String? hint}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label.toString()),
        SizedBox(
          width: 10,
        ),
        Text(
          hint.toString(),
          style: TextStyle(color: Colors.black45),
        )
      ],
    );
  }
}
