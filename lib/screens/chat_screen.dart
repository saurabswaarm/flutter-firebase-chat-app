import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
Firestore _store = Firestore.instance;
FirebaseUser currentUser;

final ScrollController _scrollController = ScrollController(initialScrollOffset: 00.0);

class ChatScreen extends StatefulWidget {
  static String route = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message;

  //textcontroller
  final TextEditingController _textController = TextEditingController();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        currentUser = user;
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
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
                _auth.signOut();
                Navigator.popUntil(
                    context,
                    (Route route) =>
                        route.settings.name == WelcomeScreen.route);

                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        //
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // id card
            Container(
              // decoration: BoxDecoration(color: Colors.red[100]),
              padding: EdgeInsets.all(2),
              child: Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentUser.email == null ? 'Loading' : currentUser.email,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            Expanded(
              child: MessageStreamBuilder(),
            ),

            //\\//\\//\\
            // input area
            Container(
              decoration: kMessageContainerDecoration,
              //
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  //
                  FlatButton(
                    onPressed: ()  {
                       _store.collection('messages').add(
                          {'message': message, 'sender': currentUser.email, 'date': DateTime.now().toString()});

                      _textController.clear();
                      _scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
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

// String getTimeNow() {

//   DateTime timeNow = DateTime.now();
//   int hour = timeNow.hour;
//   int minute = timeNow.minute;
//   int second = timeNow.second;

//   return '$hour:$minute:$second';
// }

class MessageBubble extends StatelessWidget {
  final String senderName;
  final String messageText;
  final bool isMe;

  MessageBubble({this.senderName, this.messageText, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            child: Text(senderName),
          ),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: isMe? Radius.circular(0): Radius.circular(8),
              topLeft: isMe? Radius.circular(8) : Radius.circular(0),
              topRight: Radius.circular(8),
            ),
            color: isMe ? Colors.blue : Colors.green.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                messageText,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.collection('messages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List forCompare = [];
        for (DocumentSnapshot document in snapshot.data.documents) {
          String message = document.data['message'];
          String sender = document.data['sender'];
          String dateString = document.data['date'];
          DateTime date = DateTime.parse(dateString);

          List<dynamic> objects = [message,sender,date];
          forCompare.add(objects);
        }

        forCompare.sort((a,b)=>b[2].compareTo(a[2]));

        List<Widget> chatItems = [];

        for(List item in forCompare){
          chatItems.add(MessageBubble(
            senderName: item[1],
            messageText: item[0],
            isMe: item[1] == currentUser.email, //checking to see who the sender is
          ));
        }
        return ListView(
          addAutomaticKeepAlives: true,
          controller: _scrollController,
          reverse:true,
          children: chatItems,
        );
      },
    );
  }
}
