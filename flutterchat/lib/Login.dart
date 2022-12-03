import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSignUp = false; //지금 Sign Up 중 인지 확인하는 용도

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width - 100,
      height: 350,
      duration: Duration.zero,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSignUp = false;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSignUp ? Colors.black26 : Colors.black54,
                      ),
                    ),
                    if (!isSignUp)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 2,
                        width: 55,
                        color: Colors.redAccent,
                      )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSignUp = true;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: !isSignUp ? Colors.black26 : Colors.black54,
                      ),
                    ),
                    if (isSignUp)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 2,
                        width: 75,
                        color: Colors.redAccent,
                      )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.black26,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26
                            ),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(35)
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.redAccent
                            ),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(35)
                            )
                        ),
                        hintText: 'User ID',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black26
                        ),
                        contentPadding: EdgeInsets.all(5)
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.key,
                          color: Colors.black26,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black26
                            ),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(35)
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.redAccent
                            ),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(35)
                            )
                        ),
                        hintText: 'PASSWORD',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black26
                        ),
                        contentPadding: EdgeInsets.all(5)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
