import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  OTPInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 400,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  OTPInputWidget(controller: _controller),
                  Opacity(
                    opacity:
                        0.01, // Praticamente invisível, mas ainda funcional
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Digite seu OTP',
                      ),
                      style: const TextStyle(
                        color: Colors.transparent,
                      ),
                      cursorColor: Colors.black,
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

class OTPInputWidget extends StatefulWidget {
  final TextEditingController controller;

  const OTPInputWidget({super.key, required this.controller});

  @override
  OTPInputWidgetState createState() => OTPInputWidgetState();
}

class OTPInputWidgetState extends State<OTPInputWidget> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<bool> _isFocused = List.generate(6, (index) => false);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateOTP);
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {
          _isFocused[i] = _focusNodes[i].hasFocus;
        });
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateOTP);
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _updateOTP() {
    setState(() {
      final text = widget.controller.text;
      for (int i = 0; i < _controllers.length; i++) {
        if (i < text.length) {
          _controllers[i].text = text[i];
        } else {
          _controllers[i].clear();
        }
      }
    });
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
    final isNextDigit = widget.controller.text.length == index;
    final isFocused = _isFocused[index];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: isFocused || isNextDigit ? Colors.green : Colors.black,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        decoration: const InputDecoration(border: InputBorder.none),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        showCursor: true,
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}
