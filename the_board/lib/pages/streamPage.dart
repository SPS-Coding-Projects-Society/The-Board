import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart' show rootBundle;



class MyMessage extends StatelessWidget {
  MyMessage(this.heading, this.messageBody, this.time, this.user);
  final String heading, messageBody, time, user;
@override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
          Text(messageBody, textAlign: TextAlign.left),
          Text("Uploaded at: "+time+"by "+user, textAlign:TextAlign.right)
          
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
    List<String> datalist = data.split("\n");

    int lineCount = datalist.length;
    var myMessageList = [];
    for(int i = 0; i < lineCount;i+=4){
      myMessageList.add(MyMessage(datalist[i],datalist[i+1], datalist[i+2], datalist[i+3]));
    }
    
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
          ),
          


        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.add_rounded),
        backgroundColor: Colors.blue,
        ),
    );
  }
}



Widget futureList(myMessageList) {
  return FutureBuilder(
    future: myMessageList,
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.waiting) {
        return new Center(
          child: new CircularProgressIndicator(),
            );
      } else if (projectSnap.hasError) {
        return new Text('Error: ${projectSnap.error}');
      } else {
        final items = projectSnap.data;
          return new Scrollbar(
            child: new RefreshIndicator(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  //Even if zero elements to update scroll
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
                  ),
                  onRefresh: () {
                    // implement later
                    return;
                  } // refreshList,
              ),
            );
          }// else
    }
  );
}
