import 'package:final_bluetooth/custom_card.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 3,
        shadowColor: Colors.grey.shade800,
        centerTitle: true,
          title: const Text('Home',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ))
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            MyCardButton(width: 400,
                height: 200,
                color: Colors.blue.shade200,
                onPressed: (){
              Navigator.pushNamed(context, '/third');
            }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.search_off_rounded,size: 50,),
              Text('Search For Devices',style: TextStyle(
                  fontSize: 20
              ),
              )
              ],
            )),
            MyCardButton(width: 400,
                height: 200,
                color: Colors.purple.shade100,
                onPressed: (){
                  Navigator.pushNamed(context, '/second');
                }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.auto_stories_rounded,size: 50,),
                    Text('Class Data',style: TextStyle(
                          fontSize: 20
                      ),)
                    ]
                )),
            MyCardButton(width: 400,
                height: 200,
                color: Colors.blue.shade200,
                onPressed: (){
                  Navigator.pushNamed(context, '/fourth');
                }, child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.group_add,size: 50,),
                    Text('Take Attendance',style: TextStyle(
                      fontSize: 20
                    ),)
                  ])),


          ],
        ),
      )
      ,
    );
  }
}
