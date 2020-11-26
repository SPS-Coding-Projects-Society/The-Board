import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart' show rootBundle;



class MyMessage extends StatelessWidget {
  MyMessage(this.heading, this.messageBody);
  final String heading, messageBody;
@override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 1],
          colors: [Color(0xffffffff),Color(0xffffffff),]
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(heading, textScaleFactor: 1.5, textAlign: TextAlign.left),
          Text(messageBody, textAlign: TextAlign.left)
        ],
      )
      );
  }
}

class MyItem extends StatelessWidget {
  // const MyItem(;
  MyItem(this.fileName);
  final String fileName;
@override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 1],
          colors: [Color(0xffffffff),Color(0xffffffff),]
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage('assets/images/'+fileName))
        ],
      ),
    );
  }
}


class StreamPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return StreamPageState();
  }
  
  static Future<String> loadAsset() async
  {
    String result = await rootBundle.loadString('assets/text/notices.txt');
    return result;
  }

  
  
}



class StreamPageState extends State<StreamPage>  {
  @override
  
  

  List getCardList()
  {
    int cardCount = 1;
    List myCardList = [MyItem('sps.jpg'),MyItem('sps2.jpg')];
    return myCardList;
  }

  Future<List> getMessageList() async
  {
    
    String data = await StreamPage.loadAsset();

    int lineCount = 30;
    List myMessageList = [];
    for(int i = 0; i < lineCount;i+=2)
    {
      myMessageList.add(MyMessage("a","b"));
    }

    myMessageList.add(MyMessage(data,'Come to ImpSoc!'));
    myMessageList.add(MyMessage('Computing Projects Society', 'Come to Computing Projects Society!'));

    return myMessageList;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Widget build(BuildContext context) {
    List myCardList = getCardList();
    Future<List> myMessageList = getMessageList();
    // List myMessageList = [MyMessage('Impsoc','Come to ImpSoc!'),MyMessage('Computing Projects Society', 'Come to Computing Projects Society!')];
    return Scaffold(
      body: Column(
        children: <Widget>[
          CarouselSlider(options: CarouselOptions(
                height: 300.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                aspectRatio: 2.0,
                // onPageChanged: (index, reason) {
                //   setState(() {
                //     _currentIndex = index;
                //   });
                // },
              ),
                items: myCardList.map((card){
                return Builder(
                  builder:(BuildContext context){
                    return Container(
                      height: MediaQuery.of(context).size.height*0.30,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.blueAccent,
                        child: card,
                      ),
                    );
                  }
                );
              }).toList(),
          ),
          Expanded(child:
          futureList(myMessageList)
          )
        ],
      ),
    );
  }

  

}

Widget futureList(myMessageList) {
  return FutureBuilder(
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.none &&
          projectSnap.hasData == null) {
        //print('project snapshot data is: ${projectSnap.data}');
        return Container();
      }
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // itemCount: myMessageList.length,
        itemBuilder: (context, index){
          return myMessageList[index];
        }
      );
    }
  );
}
