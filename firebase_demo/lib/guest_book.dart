import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'src/widgets.dart';
import 'guest_book_message.dart';


class GuestBook extends StatefulWidget {
  const GuestBook({
    super.key, 
    required this.addMessage, 
    required this.messages,
  });

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages; 

  @override
  _GuestBookState createState() => _GuestBookState();
}


class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  Color pickerColor = Colors.black;
  final Color currentColor = Colors.black;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  onLongPress: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick text color'),
                        content: SingleChildScrollView(
                          child: HueRingPicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                      );
                    }); 
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.message}', currentColor),
        const SizedBox(height: 8),
      ],
    );
  }
}

