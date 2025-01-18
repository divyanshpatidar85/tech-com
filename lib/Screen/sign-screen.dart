import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simpleapp/Custom/textfield.dart';
import 'package:simpleapp/backend/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: _emailcontroller,
                        labelText: "Email",
                        hintText: "Enter Your Email",
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: "Password",
                        hintText: "Enter Your Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                String res = await Authentication().signUp(
                                  email: _emailcontroller.text,
                                  password: _passwordController.text,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                if (res == "success") {
                                  Fluttertoast.showToast(
                                    msg: "Account Created, now try to login",
                                    timeInSecForIosWeb: 3,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: res,
                                    timeInSecForIosWeb: 3,
                                  );
                                }
                              },
                              child: Text('Sign Up'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
