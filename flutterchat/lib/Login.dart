import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/add_image/add_image.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authentication = FirebaseAuth.instance;

  bool isSignUp = false; //지금 Sign Up 중 인지 확인하는 용도
  final _formKey = GlobalKey<FormState>();
  String regKey = '';
  String userID = '';
  String passwd = '';
  bool showSpinner = false;
  File? userPickedImage;

  void pickedImage(File image) {
    userPickedImage = image;
  }

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: AddImage(pickedImage),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Center(
            child: AnimatedContainer(
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
                              Row(
                                children: [
                                  Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignUp ? Colors.black26 : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if(isSignUp)
                                  GestureDetector(
                                    onTap: () {
                                      showAlert(context);
                                    },
                                    child: Icon(
                                      Icons.image,
                                      color: isSignUp ? Colors.cyan : Colors.grey[300],
                                    ),
                                  )
                                ],
                              ),
                              if (isSignUp)
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 3, 35, 0),
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
                                regKey = value!;
                              },
                              validator: (value){
                                if(value!.isEmpty || value.length < 6){ //null 이면 안돼서 null check
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
                              obscureText: true,
                              key: const ValueKey(2),
                              onSaved: (value){
                                passwd = value!;
                              },
                              validator: (value){
                                if(value!.isEmpty || value.length < 6){ //null 이면 안돼서 null check
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
                        onTap: () async{
                          setState(() {
                            showSpinner = true;
                          });
                          _tryValidation();

                          try {
                            await _authentication.
                            signInWithEmailAndPassword(
                                email: regKey,
                                password: passwd
                            );
                          }catch(e) {
                            setState(() {
                              showSpinner = false;
                            });
                            print(e);
                          }
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
                      )
                    ], // login page
                    if(isSignUp)...[
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                key: const ValueKey(3),
                                onSaved: (value){
                                  regKey = value!;
                                },
                                validator: (value){
                                  if(value!.isEmpty || value.length < 6){ //null 이면 안돼서 null check
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
                                  if(value!.isEmpty || value.length < 6){ //null 이면 안돼서 null check
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
                                obscureText: true,
                                key: const ValueKey(5),
                                onSaved: (value){
                                  passwd = value!;
                                },
                                validator: (value){
                                  if(value!.isEmpty || value.length < 6){ //null 이면 안돼서 null check
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
                        onTap: () async{
                          setState(() {
                            showSpinner = true;
                          });
                          if(userPickedImage == null) {
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please pick your image"),
                                  backgroundColor: Colors.grey,
                                ),
                            ) ;
                            return;
                          }
                          _tryValidation();

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: regKey,
                              password: passwd,
                            );


                            final refImage = FirebaseStorage.instance.ref()
                                .child('picked_image')
                                .child('${newUser.user!.uid}.png');

                            await refImage.putFile(userPickedImage!);
                            final url = await refImage.getDownloadURL();

                            await FirebaseFirestore.instance
                                .collection("user")
                                .doc(newUser.user!.uid)
                                .set(
                                  {
                                    'username':userID,
                                    'email':regKey,
                                    "picked_image" : url,
                                  }
                                );
                            
                          }catch(e){
                            print('@@@@@@@@@@@@@@@@');
                            print(e);
                            if(mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please check your email and password"),
                                    backgroundColor: Colors.grey,
                                  )
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
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
            ),
    ),
          ),
        ),
      );
  }
}
