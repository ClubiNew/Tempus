import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tempus/screens/login/sms_login_state.dart';
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
          builder: (context) => ChangeNotifierProvider(
            create: (context) => SmsLoginState(),
            child: SmsLoginPage(),
          ),
        ),
      ),
    );
  }
}

class SmsLoginPage extends StatelessWidget {
  SmsLoginPage({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void onSubmitted(SmsLoginState state) {
    String input = _controller.text.trim();
    if (!state.smsSent) {
      state.sendSmsCode(input, () {
        _controller.text = "";
        _focusNode.requestFocus();
      });
    } else {
      state.verifySmsCode(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    SmsLoginState state = Provider.of<SmsLoginState>(context);
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
                readOnly: state.isWaiting,
                controller: _controller,
                keyboardType:
                    state.smsSent ? TextInputType.number : TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: state.smsSent ? "SMS code" : "Phone number",
                ),
                onSubmitted: state.isWaiting ? null : (_) => onSubmitted(state),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            state.isWaiting ? null : () => onSubmitted(state),
                        child: const Text("Submit"),
                      ),
                    ),
                    Container(
                      width: 8,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            state.isWaiting ? null : Navigator.of(context).pop,
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    state.errorMessage ?? "",
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
