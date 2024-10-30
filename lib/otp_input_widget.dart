import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OTPInputWidget extends StatefulWidget {
  final TextEditingController controller;

  const OTPInputWidget({super.key, required this.controller});

  @override
  OTPInputWidgetState createState() => OTPInputWidgetState();
}

class OTPInputWidgetState extends State<OTPInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateOTP);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateOTP);
    super.dispose();
  }

  void _updateOTP() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return _buildOTPDigit(index);
      }),
    );
  }

  Widget _buildOTPDigit(int index) {
    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.controller.text.length > index
            ? widget.controller.text[index]
            : '',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

class OTPInputScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  OTPInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: MouseRegion(
            cursor: MaterialStateMouseCursor.textable,
            child: GestureDetector(
              onTap: () {
                focusNode.requestFocus();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  OTPInputWidget(controller: _controller),
                  Visibility(
                    visible: false,
                    maintainState: true,
                    child: TextField(
                      controller: _controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite seu OTP',
                      ),
                      style: const TextStyle(
                          color: Colors
                              .transparent), // Oculta o texto do TextField.
                      cursorColor: Colors.transparent,
                      enableInteractiveSelection: false,
                      onChanged: (value) {
                        if (value.length == 6) {
                          // Ação ao completar os 6 dígitos
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
