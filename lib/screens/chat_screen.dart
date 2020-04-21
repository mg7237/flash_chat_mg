import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  FirebaseUser currentUser;
  String txtMessage = '';

  final messageTextController = TextEditingController();

  void messageStream() async {
    await for (var messageList
        in _fireStore.collection('messages').snapshots()) {
      for (var message in messageList.documents) {
        print(message.data);
      }
    }
  }

  void getMessages() async {
    {
      final messages = await _fireStore.collection('messages').getDocuments();
      for (var message in messages.documents) {
        print(message.data);
      }
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      currentUser = user;
      if (currentUser == null) {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
              })

//                _auth.signOut();
//                Navigator.pop(context);
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data.documents.reversed;
                    List<Widget> messageText = [];
                    for (final message in messages) {
                      final String msgText = message.data['text'];
                      final String sender = message.data['email'];
                      final bool isMeLocal =
                          sender.trim() == currentUser.email ? true : false;
                      messageText.add(Bubble(
                          text: msgText, email: sender, isMe: isMeLocal));
                    }

                    return ListView(
                      children: messageText,
                      padding: EdgeInsets.all(20),
                      reverse: true,
                      itemExtent: 80,
                      shrinkWrap: true,
                    );
                  },
                ),
              )),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          txtMessage = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _fireStore.collection('messages').add(
                            {'email': currentUser.email, 'text': txtMessage});
                        messageTextController.clear();
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
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String text;
  final String email;
  final bool isMe;

  Bubble({this.email, this.text, this.isMe});

  @override
  Widget build(BuildContext context) {
    return (Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$email',
          style: TextStyle(color: Colors.grey),
        ),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: (isMe ? Colors.red : Colors.blue),
              borderRadius: (isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))
                  : BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              border: Border.all(
                  color: Colors.greenAccent, style: BorderStyle.solid)),
          child: Text(
            '$text',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
  }
}
