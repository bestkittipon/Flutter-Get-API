import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:async';
import 'dart:convert';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _futureUsersFromGitHub() async{
    final response = await http.get('https://api.github.com/users');
    List responseJson = json.decode(response.body.toString());
    List<User> userList = createUserList(responseJson);
    return userList;
  }

  List<User> createUserList(List data) {
    List<User> list = List();
    for (int i = 0; i < data.length;i++){
      String title =data[i]["login"];
      int id = data[i]["id"];
      String avatarUrl = data[i]["avatar_url"];
      User user = User(name: title , id: id , avatarUrl: avatarUrl);
      list.add(user);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder<List<User>>(
          future: _futureUsersFromGitHub(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount:snapshot.data.length,
                  itemBuilder: (context , index){
                    return Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Image.network(
                              snapshot.data[index].avatarUrl,
                              width: 50.0,
                            )
                          ),
                          Text(snapshot.data[index].name)
                        ],
                      ),
                      Divider()
                    ],);
              });
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
