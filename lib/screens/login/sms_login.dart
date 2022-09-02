import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'login_button.dart';

class SmsLoginButton extends StatelessWidget {
  const SmsLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginButton(
      icon: FontAwesomeIcons.commentSms,
      buttonColor: Colors.green,
      text: 'Login with SMS',
      loginMethod: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SmsLoginPage(),
        ),
      ),
    );
  }
}

class SmsLoginPage extends StatefulWidget {
  const SmsLoginPage({Key? key}) : super(key: key);

  @override
  State<SmsLoginPage> createState() => _SmsLoginPageState();
}

class _SmsLoginPageState extends State<SmsLoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  ConfirmationResult? confirmationResult;
  String? verificationId;
  bool smsSent = false;

  bool isWaiting = false;
  String? errorMessage;

  void sendSmsCode() async {
    String phoneNumber = _controller.text.trim();
    setState(() => isWaiting = true);

    // google expects +[country] in-front of 10 digits
    if (!phoneNumber.startsWith('+')) {
      if (phoneNumber.startsWith('1') && phoneNumber.length > 10) {
        phoneNumber = '+$phoneNumber';
      } else {
        phoneNumber = '+1$phoneNumber';
      }
    }

    if (kIsWeb) {
      auth.signInWithPhoneNumber(phoneNumber).then((result) {
        successfullySentSms(null, result);
      }).catchError((error) {
        failedToSendSms(error);
      });
    } else {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          failedToSendSms(e);
        },
        codeSent: (String verificationId, _) {
          successfullySentSms(verificationId, null);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          successfullySentSms(verificationId, null);
        },
      );
    }
  }

  void successfullySentSms(String? id, ConfirmationResult? result) {
    setState(() {
      confirmationResult = result;
      verificationId = id;
      _controller = TextEditingController();
      errorMessage = null;
      isWaiting = false;
      smsSent = true;
    });
    _focusNode.requestFocus();
  }

  void failedToSendSms(dynamic error) {
    late String message;

    if (error.code == 'invalid-phone-number') {
      message = "Invalid phone number";
    } else if (error.code == 'too-many-request') {
      message = "Too many requests";
    } else {
      message = "Unknown error sending SMS";
      print(error);
    }

    setState(() {
      errorMessage = message;
      isWaiting = false;
    });
  }

  void verifySmsCode() {
    String smsCode = _controller.text.trim();
    if (kIsWeb) {
      confirmationResult!.confirm(smsCode).catchError((error) {
        failedToVerifySmsCode(error);
      });
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );

      auth.signInWithCredential(credential).catchError((error) {
        failedToVerifySmsCode(error);
      });
    }
  }

  void failedToVerifySmsCode(dynamic error) {
    late String message;

    if (error.code == 'invalid-verification-code') {
      message = "Invalid code";
    } else {
      message = "Failed to verify code";
      print(error);
    }

    setState(() {
      errorMessage = message;
      isWaiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                autofocus: true,
                focusNode: _focusNode,
                readOnly: isWaiting,
                controller: _controller,
                keyboardType:
                    smsSent ? TextInputType.number : TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: smsSent ? "SMS code" : "Phone number",
                ),
                onSubmitted: (_) {
                  if (!smsSent) {
                    sendSmsCode();
                  } else {
                    verifySmsCode();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isWaiting
                            ? null
                            : () {
                                if (!smsSent) {
                                  sendSmsCode();
                                } else {
                                  verifySmsCode();
                                }
                              },
                        child: const Text("Submit"),
                      ),
                    ),
                    Container(
                      width: 8,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isWaiting ? null : Navigator.of(context).pop,
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
