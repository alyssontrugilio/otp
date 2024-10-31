import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInputWidget extends StatefulWidget {
  final int length;
  final double width;
  final double height;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const OTPInputWidget({
    super.key,
    this.length = 6,
    this.width = 44,
    this.height = 48,
    this.borderColor = Colors.black,
    this.focusedBorderColor = Colors.green,
    this.errorBorderColor = Colors.red,
    this.onChanged,
    this.validator,
    this.inputFormatters,
  });

  @override
  OTPInputWidgetState createState() => OTPInputWidgetState();
}

class OTPInputWidgetState extends State<OTPInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<FocusNode> _focusNodes = [];
  int _currentIndex = 0;
  String? _errorText;

  static const double radius = 5.0;
  static const double fontSize = 17.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateOTP);
    for (int i = 0; i < widget.length; i++) {
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateOTP);
    _controller.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _updateOTP() {
    setState(() {
      _currentIndex = _controller.text.length;
      if (_currentIndex < widget.length) {
        _focusNodes[_currentIndex].requestFocus();
      }
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
      if (widget.validator != null) {
        _errorText = widget.validator!(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = BoxDecoration(
      border: Border.all(color: widget.borderColor),
      borderRadius: BorderRadius.circular(radius),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      border: Border.all(
        color: widget.errorBorderColor,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      border: Border.all(
        width: 2,
        color: widget.focusedBorderColor,
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: MaterialStateMouseCursor.textable,
          child: GestureDetector(
            onTap: () {
              if (_currentIndex < widget.length) {
                _focusNodes[_currentIndex].requestFocus();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.length, (index) {
                    return _buildOTPDigit(
                        index, defaultPinTheme, focusedPinTheme, errorPinTheme);
                  }),
                ),
                Visibility(
                  visible: false,
                  maintainState: true,
                  child: TextField(
                    controller: _controller,
                    focusNode: _currentIndex < widget.length
                        ? _focusNodes[_currentIndex]
                        : null,
                    keyboardType: TextInputType.number,
                    maxLength: widget.length,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: widget.inputFormatters,
                    style: const TextStyle(color: Colors.transparent),
                    cursorColor: Colors.transparent,
                    enableInteractiveSelection: false,
                    onChanged: (value) {
                      if (value.length == widget.length) {}
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  _errorText!,
                  style: TextStyle(
                    color: widget.errorBorderColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOTPDigit(int index, BoxDecoration defaultPinTheme,
      BoxDecoration focusedPinTheme, BoxDecoration errorPinTheme) {
    final isCurrent = index == _currentIndex;
    final decoration = _errorText != null
        ? errorPinTheme
        : (isCurrent ? focusedPinTheme : defaultPinTheme);
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: decoration,
      child: Text(
        _controller.text.length > index ? _controller.text[index] : '',
        style: const TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
