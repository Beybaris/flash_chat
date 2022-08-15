import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  MessageBubble({required this.text, required this.sender, required this.ItIsMe});

  final String text;
  final String sender;
  final bool ItIsMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        ItIsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topLeft: (ItIsMe ? Radius.circular(30.0) : Radius.circular(0)),
              topRight: (ItIsMe ? Radius.circular(0) : Radius.circular(30.0)),
            ),
            elevation: 5.0,
            color: ItIsMe ? Colors.lightBlueAccent : Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
