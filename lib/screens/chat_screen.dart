import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedUser;
  late String messageText;
  final messageTextController = TextEditingController();


  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for(var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messageStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()) {
      for(var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if(user != null) {
        loggedUser = user;
        print(loggedUser.email);

      }
    } catch(e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                }
                final messages = snapshot.data?.docs;
                List<MessageBubble> messageBubbles = [];
                for(var message in messages!) {
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  final messageBubble = MessageBubble(sender: messageSender, text: messageText,);
                  messageBubbles.add(messageBubble);
                }

                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    children: messageBubbles,
                  ),
                );
              }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedUser.email,
                        'text' : messageText,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  
  MessageBubble({required this.text, required this.sender});
  
  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender, style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
          ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 5.0,
            color: Colors.lightBlueAccent,
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

