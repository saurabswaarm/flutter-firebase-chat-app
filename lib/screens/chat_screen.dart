import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static String route = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String message;

  String getTimeNow() {
    DateTime timeNow = DateTime.now();
    int hour = timeNow.hour;
    int minute = timeNow.minute;
    int second = timeNow.second;

    return '$hour:$minute:$second';
  }

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
            //
            MessageList(),

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
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  //
                  FlatButton(
                    onPressed: () {
                      Firestore.instance
                          .collection('messages')
                          .document()
                          .setData({
                        'message': message,
                        'user': currentUser.email,
                        'time': getTimeNow()
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

class MessageList extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('messages').snapshots(),
      //
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Waiting');
        } else {
          //
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              //
              children: snapshot.data.documents.map<Widget>(
                 (DocumentSnapshot document) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document['message'], style: kChatbubbleStyle),
                          ),
                        ),
                        Text(document['time'], style: TextStyle(fontSize: 10))
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}

//  <Widget>[
//                   //chat bubble
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       textDirection: TextDirection.ltr,
//                       crossAxisAlignment: CrossAxisAlignment.baseline,
//                       textBaseline: TextBaseline.alphabetic,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         Card(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('one message' ,style: kChatbubbleStyle),
//                           ),
//                         ),
//                         Text(getTimeNow(),style: TextStyle(fontSize:10))
//                       ],
//                     ),
//                   )
//                 ]
