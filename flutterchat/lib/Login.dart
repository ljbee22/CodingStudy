import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSignUp = false; //지금 Sign Up 중 인지 확인하는 용도
  final _formKey = GlobalKey<FormState>();
  String regKey = '';
  String userID = '';
  String passwd = '';

  void _tryValidation(){
    /* 이를 통해 모든 text-form field의 validator를 작동*/
    /*currentState에 근거해야하므로, 즉 null이 되면 안되므로 nullcheck with !*/
    final isValid = _formKey.currentState!.validate();
  }

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
      child: SingleChildScrollView(
        /*scroll 기능 추가. validation에서 경고를 띄워서 overflow 방지+ 키보드 올린 상태에서 입력가능 */
        padding: const EdgeInsets.only(bottom: 20),
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
                ),//login
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
                ),//sign-up
              ],
            ), // login, sign-up
            if(!isSignUp)...[
              Container(
              margin: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey(1),
                      onSaved: (value){
                        userID = value!;
                      },
                      validator: (value){
                        if(value!.isEmpty || value!.length < 6){ //null 이면 안돼서 null check
                          return "Please enter at least 6 characters";
                        }
                        return null;
                      },
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
                      key: const ValueKey(2),
                      onSaved: (value){
                        passwd = value!;
                      },
                      validator: (value){
                        if(value!.isEmpty || value!.length < 6){ //null 이면 안돼서 null check
                          return "Password must be at least 7 characters long";
                        }
                        return null;
                      },
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
                          hintText: 'Password',
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
            ), // text field for
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: (){
                  _tryValidation();
                },
                child: Container(
                  margin: const EdgeInsets.only(top:35),
                  height: 35,
                  width: 85,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black26,
                        Colors.black38,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right_sharp,
                  ),
                ),
              )//button to the next
            ], // login page
            if(isSignUp)...[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const ValueKey(3),
                        onSaved: (value){
                          regKey = value!;
                        },
                        validator: (value){
                          if(value!.isEmpty || value!.length != 6){ //null 이면 안돼서 null check
                            return "Please check you registration key";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_lock,
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
                            hintText: 'Registration Key',
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
                        key: const ValueKey(4),
                        onSaved: (value){
                          userID = value!;
                        },
                        validator: (value){
                          if(value!.isEmpty || value!.length < 6){ //null 이면 안돼서 null check
                            return "Please enter at least 6 characters";
                          }
                          return null;
                        },
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
                        key: const ValueKey(5),
                        onSaved: (value){
                          passwd = value!;
                        },
                        validator: (value){
                          if(value!.isEmpty || value!.length < 6){ //null 이면 안돼서 null check
                            return "Password must be at least 7 characters long";
                          }
                          return null;
                        },
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
                            hintText: 'Password',
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
              ), // text field for sign-up
              GestureDetector(
                onTap: (){
                  _tryValidation();
                },
                child: Container(
                  margin: const EdgeInsets.only(top:35),
                  height: 35,
                  width: 85,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black26,
                        Colors.black38,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right_sharp,
                  ),
                ),
              )//button to the next
            ], // sign up page
          ],
        ),
      ),
    );
  }
}
