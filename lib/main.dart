import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textInput = TextEditingController();

  List<Map>Message=[];
  Future<String> getReply(userInput) async{
    var response = await http.get(Uri.parse("http://api.brainshop.ai/get?bid=171371&key=9ZfN1zcFnyZGQDUr&uid=[uid]&msg=[${userInput}]"));
    var body = jsonDecode(response.body);
    setState(() {
      Message.insert(
        0,{
        "data":0,
        "message":body['cnt'],
        }


      );

    });
    print(Message[0]['message']);
    return body['cnt'];
  }
  Widget chat(String userInput,int data){
    return Row(
      mainAxisAlignment: data==1?MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
            data==0?Padding(
              padding: const EdgeInsets.only(left: 20,right:20),
              child: Container(
                height: 60,
                width: 60,
                child: CircleAvatar(
                  backgroundImage:AssetImage("assets/robot.jpg"),
                ),
              ),
            ):Container(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Bubble(
                radius: Radius.circular(18.0),
                color: data==0?Color.fromARGB(225, 255, 199, 1):Colors.white,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            userInput,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ,
        data==1? Container(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/defalut.jpg"),
          ),
        ) : Container()
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Bot07"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: Message.length,

                    itemBuilder: (context, index) => chat(Message[index]['message'], Message[index]['data']),
                  ),
                ),
                    Divider(
                      height: 2,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Color.fromRGBO(220, 220, 220, 1),
                            ),
                            child: Row(
                              children: [
                                
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0,bottom: 8.0),
                                    child: TextFormField(
                                      controller: textInput,
                                      decoration: InputDecoration(
                                        hintText: "Type Here!",
                                        hintStyle: TextStyle(
                                          color: Colors.black

                                        ),

                                        border: InputBorder.none
                                      ),
                                      style: TextStyle(
                                          color:Colors.black,

                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(onPressed:(){
                                  if(textInput.text.isEmpty){
                                    print("Empty Message");
                                  }
                                  else{
                                    setState(() {
                                      Message.insert(0,{"data":1,"message":textInput.text});
                                    });
                                    getReply(textInput.text);
                                    textInput.clear();
                                  }
                                  FocusScopeNode currentFocus=FocusScope.of(context);
                                  if(!currentFocus.hasPrimaryFocus){
                                    currentFocus.unfocus();
                                  }
                                }, icon: Icon(Icons.send))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
              ],
            ),
      )
    );
  }
}
