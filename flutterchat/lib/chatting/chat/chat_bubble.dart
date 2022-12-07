import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, this.isMe, this.userID, {Key? key}) : super(key: key);

  final String message;
  final bool isMe;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isMe)... [
              Container(
                width: 145,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                    'Hello',
                    textAlign: TextAlign.start
                  ),
              ),
              ],
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12)
                ),
              ),
              width: 145,
              padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16
              ),
              margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: isMe ? Colors.black : Colors.white
                ),
              ),
            ),
          ],
        ),
      ]
    );
  }
}
