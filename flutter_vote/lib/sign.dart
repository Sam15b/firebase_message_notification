import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vote/main_camera.dart';
import 'package:flutter_vote/notificationservice/local_notification_service.dart';
import 'package:flutter_vote/services/api.dart';
import 'package:flutter_vote/sign3.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vote/sign2.dart';

class SignPage extends StatefulWidget {
  // final List<CameraDescription> cameras;
  SignPage({super.key});
  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  NotificationServices notificationServices = NotificationServices();

  String? fcm_token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        fcm_token = value;
        print('device token');
        print(value);
        print("fcm_token $fcm_token");
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        print("New Notification");
        if (message.data['_id'] != null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignPage3()));
        }
      }
    });
  }
  // initState() {
  //   super.initState();

  //   // 1. This method call when app in terminated state and you get a notification
  //   // when you click on notification app open from terminated state and you can get notification data in this method

  //   FirebaseMessaging.instance.getInitialMessage().then(
  //     (message) {
  //       print("FirebaseMessaging.instance.getInitialMessage");
  //       if (message != null) {
  //         print("New Notification");
  //         // if (message.data['_id'] != null) {
  //         //   Navigator.of(context).push(
  //         //     MaterialPageRoute(
  //         //       builder: (context) => DemoScreen(
  //         //         id: message.data['_id'],
  //         //       ),
  //         //     ),
  //         //   );
  //         // }
  //       }
  //     },
  //   );

  //   // 2. This method only call when App in forground it mean app must be opened
  //   FirebaseMessaging.onMessage.listen(
  //     (message) {
  //       print("FirebaseMessaging.onMessage.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data11 ${message.data}");
  //         LocalNotificationService.createanddisplaynotification(message);

  //       }
  //     },
  //   );

  //   // 3. This method only call when App in background and not terminated(not closed)
  //   FirebaseMessaging.onMessageOpenedApp.listen(
  //     (message) {
  //       print("FirebaseMessaging.onMessageOpenedApp.listen");
  //       if (message.notification != null) {
  //         print(message.notification!.title);
  //         print(message.notification!.body);
  //         print("message.data22 ${message.data['_id']}");
  //       }
  //     },
  //   );
  // }

  get http => null;

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  // Future<void> post() async {
  @override
  Widget build(BuildContext context) {
    // var a = MediaQuery.sizeOf(context).height;
    // var w = MediaQuery.sizeOf(context).width;
    TextEditingController _FirstName = TextEditingController();
    TextEditingController _LastName = TextEditingController();
    TextEditingController _Phone = TextEditingController();
    TextEditingController _email = TextEditingController();
    TextEditingController _Pass = TextEditingController();
    TextEditingController _addar = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bac_app.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    child: Text(
                      "Fill the Details",
                      style: TextStyle(
                          color: Colors.lightGreenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 50,
                          width: 150,
                          child: TextFormField(
                            controller: _FirstName,
                            onChanged: (value) {
                              if (value.length == 10) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your First Name';
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "First Name",
                                labelText: "First Name",
                                hintStyle: TextStyle(color: Colors.white54),
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white70),
                                    borderRadius: BorderRadius.circular(20)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 50,
                          width: 150,
                          child: TextFormField(
                            controller: _LastName,
                            onChanged: (value) {
                              if (value.length == 10) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your Last Name';
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Last Name",
                                labelText: "Last Name",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintStyle: TextStyle(color: Colors.white54),
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Email Address';
                        } else if (!isEmail(value)) {
                          return 'Enter your coorect Email';
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _Pass,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter the Pass";
                        } else if (value.length < 5) {
                          return "Add Strong Password";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _Phone,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter the Phone Number";
                        } else if (value.length < 10) {
                          return "Enter Correct Phone Number";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Phone",
                          labelText: "Phone",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _addar,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Addar Number";
                        } else if (value.length < 12) {
                          return "Enter your Coorect Addar Number";
                        }
                      },
                      onChanged: (value) {
                        if (value.length == 4 || value.length == 8) {
                          //selection:
                          TextSelection.fromPosition(
                              TextPosition(offset: _addar.text.length));
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Addhar Number",
                          labelText: "Addhar Number",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintStyle: TextStyle(color: Colors.white54),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          var udata = {
                            "Fname": _FirstName.text,
                            "Lname": _LastName.text,
                            "Email": _email.text,
                            "Phone": _Phone.text,
                            "AddharNumber": _addar.text,
                            "fcm_token": fcm_token
                          };
                          Api.addproduct(udata);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignPage2(
                                      AddharNumber: _addar
                                          .text))); // use the email provided here
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          alignment: Alignment.center,
                          shape: StadiumBorder()),
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      ))
                ]),
          ),
        ),
      ),
    );
  }
}
