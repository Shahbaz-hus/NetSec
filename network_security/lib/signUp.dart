import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Enter Name',
                            hintText: 'Enter Your Name'
                        ),

                      )
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
