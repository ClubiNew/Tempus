import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class SmsLoginState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ConfirmationResult? _confirmationResult;
  String? _verificationId;

  String? errorMessage;
  bool isWaiting = false;
  bool smsSent = false;

  void sendSmsCode(String phoneNumber, void Function() onSent) async {
    isWaiting = true;
    notifyListeners();

    // google expects +[country] in-front of 10 digits
    if (!phoneNumber.startsWith('+')) {
      if (phoneNumber.startsWith('1') && phoneNumber.length > 10) {
        phoneNumber = '+$phoneNumber';
      } else {
        phoneNumber = '+1$phoneNumber';
      }
    }

    if (kIsWeb) {
      _auth.signInWithPhoneNumber(phoneNumber).then((result) {
        _successfullySentSms(null, result, onSent);
      }).catchError((error) {
        _failedToSendSms(error);
      });
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _failedToSendSms(e);
        },
        codeSent: (String verificationId, _) {
          _successfullySentSms(verificationId, null, onSent);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _successfullySentSms(verificationId, null, onSent);
        },
      );
    }
  }

  void _successfullySentSms(
    String? id,
    ConfirmationResult? result,
    void Function() onSent,
  ) {
    _confirmationResult = result;
    _verificationId = id;

    errorMessage = null;
    isWaiting = false;
    smsSent = true;

    notifyListeners();
    onSent();
  }

  void _failedToSendSms(dynamic error) {
    if (error.code == 'invalid-phone-number') {
      errorMessage = "Invalid phone number";
    } else if (error.code == 'too-many-request') {
      errorMessage = "Too many requests";
    } else {
      errorMessage = "Unknown error sending SMS";
      print(error);
    }

    isWaiting = false;
    notifyListeners();
  }

  void verifySmsCode(String smsCode) {
    isWaiting = true;
    notifyListeners();

    if (kIsWeb) {
      _confirmationResult!.confirm(smsCode).then((_) {
        isWaiting = false;
        notifyListeners();
      }).catchError((error) {
        _failedToVerifySmsCode(error);
      });
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      _auth.signInWithCredential(credential).then((_) {
        isWaiting = false;
        notifyListeners();
      }).catchError((error) {
        _failedToVerifySmsCode(error);
      });
    }
  }

  void _failedToVerifySmsCode(dynamic error) {
    if (error.code == 'invalid-verification-code') {
      errorMessage = "Invalid code";
    } else {
      errorMessage = "Failed to verify code";
      print(error);
    }

    isWaiting = false;
    notifyListeners();
  }
}
