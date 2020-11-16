import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

class WorkroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is material app inside AppTabBar
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/chatList',
      routes: <String, WidgetBuilder>{
        // Route to list of chats (work rooms)
        '/chatList': (BuildContext context) => GestureDetector(
              child: WorkRoomList(),
              onTap: () => FocusScope.of(context)
                  .unfocus(), // Hide keyboard when tap other parts
            ),
        // Route to chat page
        '/chat': (BuildContext context) => GestureDetector(
              child: ChatPage(),
              onTap: () => FocusScope.of(context)
                  .unfocus(), // Hide keyboard when tap other parts
            ),
      },
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            // Animation of transition which moves right to left
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    );
  }
}

//=========================================================================
// Class for workroom list to show all workrooms
class WorkRoomList extends StatelessWidget {
  final List workrooms = [
    [
      true,
      "UFM.5",
      "5.00PM",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Charlie Benello", "1:04 PM", "https://www.cl.cam.ac.uk"]
      ]
    ],
    [
      true,
      "UCO.2",
      "1.34PM",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"]
      ]
    ],
    [
      false,
      "Upper Eighth",
      "Yesterday",
      "Can someone send the link to the Jamboard from the lesson?",
      [
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"],
        ["Felix Waller", "1:24 PM", "Ah - thanks for the explanation!"]
      ]
    ],
  ];

  Widget workroomTile(List room, BuildContext context) {
    IconData classIcon;
    // Check if it is class or not
    if (room[0]) {
      classIcon = Icons.book;
    } else {
      classIcon = Icons.sports_cricket;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  // Icon of workroom
                  child: Icon(classIcon),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        // Show room name
                        child: Text(
                          room[1],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        // Show the last chat in this chat group
                        child: Text(
                          room[3],
                          maxLines: 2,
                          style:
                              TextStyle(color: Colors.grey[700]), // Last chat
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      // Show date of the last chat
                      child: Text(room[2], textAlign: TextAlign.right),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                )
              ],
            ),
          ),
          onTap: () => {
                // When tapped, hide keyboard and navigate to chat
                FocusScope.of(context).unfocus(),
                Navigator.of(context).pushNamed('/chat', arguments: room)
              }),
    );
  }

  List<Widget> workroomList(BuildContext context) {
    // This create a list of all workroom tiles
    List<Widget> list = [];
    Container line = Container(
      height: 0,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
    );
    list.add(line);
    for (List x in workrooms) {
      list.add(workroomTile(x, context));
      list.add(line);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Bottom part which shows the list of workroom
      Positioned(
        top: 50,
        left: 0,
        right: 0,
        bottom: 0,
        child: ListView(
          children: workroomList(context),
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
      // Top part whcih shows the search bar
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1.0,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                child: Row(
                  children: [
                    // Search icon
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    // Textfield to search
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

//==========================================================================
// Class for chat page
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController =
      new TextEditingController();

  String myAccount = "Charlie Benello";

  // Text entered
  String _text = '';

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Control the height of input part
  double textfieldHeight() {
    if (_text == '') {
      return 50;
    } else {
      return double.infinity;
    }
  }

  // Tile for each chat
  Widget chatTile(List chat, BuildContext context) {
    var padding;
    var radiusL;
    var radiusR;
    var accountIcon;
    var cardColor;
    var textColor;

    if (chat[0] == myAccount) {
      // If chat is mine,
      //    no account icon,
      //    aligned right,
      //    left edges are rounded
      //    tile is accent color
      //    text is accent text theme
      accountIcon = Container();
      radiusL = Radius.circular(16);
      radiusR = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(16.0, 8.0, 0, 8.0);
      cardColor = Theme.of(context).accentColor;
      textColor = Theme.of(context).accentTextTheme.bodyText1.color;
    } else {
      // If chat is mine,
      //    has account icon,
      //    aligned left,
      //    right edges are rounded
      //    tile is card color
      //    text is text theme
      accountIcon = Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
        child: Icon(
          Icons.account_circle,
          color: Theme.of(context).iconTheme.color,
        ), //Account icon
      );
      radiusR = Radius.circular(16);
      radiusL = Radius.circular(0);
      padding = EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0);
      cardColor = Theme.of(context).cardColor;
      textColor = Theme.of(context).textTheme.bodyText1.color;
    }

    return Padding(
        padding: padding,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topRight: radiusR,
              bottomRight: radiusR,
              topLeft: radiusL,
              bottomLeft: radiusL,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Account icon
                accountIcon,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Show person's name made the chat
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              chat[0],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          // Show data that the chat was posted
                          Material(
                              color: Colors.transparent,
                              child: Text(
                                chat[1],
                                style: TextStyle(color: textColor),
                                maxLines: 1,
                              )),
                        ],
                      ),
                      // Show main text
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          chat[2],
                          style: TextStyle(color: textColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // argument (list about chat) from the navigator
    final List args = ModalRoute.of(context).settings.arguments;
    // controller for listview.builder
    final ScrollController _scrollController = ScrollController();

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        // Button to go back to workroom list
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Work Rooms',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: new Text(args[1]),
        // Button to report
        trailing: IconButton(icon: Icon(Icons.error_outline)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(children: [
              // Background of chat page (Could be set by user to some pictures?)
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(color: Colors.grey[400])),
              // Flow of chats
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  controller: _scrollController,
                  // Number of chats
                  itemCount: args[4].length,
                  itemBuilder: (BuildContext context, int index) {
                    return chatTile(args[4][index], context);
                  },
                ),
              ),
            ]),
          ),
          // Input part
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: textfieldHeight()),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1.0,
                    blurRadius: 10.0,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Icon button to add a file
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 34,
                          onPressed: null,
                        ),
                      ),
                    ),
                    // Icon button to add a photo
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                          icon: Icon(Icons.photo),
                          iconSize: 34,
                          onPressed: null,
                        ),
                      ),
                    ),
                    // Text input
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(17, 5, 17, 5),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              controller: _textEditingController,
                              onChanged: _handleText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.multiline,
                              autocorrect: true,
                              autofocus: false,
                              // No limit of words number and lines
                              maxLines: null,
                              maxLength: null,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.top,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Icon button to send a chat
                    SizedBox(
                      height: 34,
                      width: 34,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: IconButton(
                            icon: Icon(Icons.send),
                            iconSize: 34,
                            onPressed: () => {
                                  _textEditingController.text = "",
                                  FocusScope.of(context).unfocus()
                                }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
