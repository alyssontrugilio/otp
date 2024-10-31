import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp_input_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _mainController = TextEditingController();

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          child: OTPInputWidget(
            length: 6,
            width: 40,
            height: 50,
            borderColor: Colors.black,
            focusedBorderColor: Colors.green,
            onChanged: (value) {
              log('OTP changed: $value');
            },
            validator: (value) {
              if (value == null) return null;
              if (value.isEmpty) return 'Preencha algo';
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ),
    );
  }
}
