import 'package:arishti_task/screens/Archieve.dart';
import 'package:arishti_task/models/Model.dart';
import 'package:arishti_task/services/RTDB.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for preventing the screenshots
    ScreenProtector.preventScreenshotOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Arishti'),
            ),
            ListTile(
              title: Text('Archive'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Archieve()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<Model>>(
            future: RTDB.getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Please wait loading...", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),),
                );
              }
              else if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Dismissible(
                        key: Key(""),
                        child: ListTile(
                          leading: Text("${index + 1}"),
                          title: Text(snapshot.data![index].brand),
                          subtitle: Text(snapshot.data![index].description),
                        ),
                        onDismissed: (direction) async {
                          print(direction);
                          if(direction == DismissDirection.endToStart) {
                            await RTDB.deleteData(snapshot.data![index]);
                            setState(() {});
                          }
                          else if(direction == DismissDirection.startToEnd) {
                            await RTDB.insertArchiveData(snapshot.data![index]);
                            setState(() {});
                          }

                        },
                        background: Container(
                          child: Center(child: Text("Archived", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey))),
                        ),

                        secondaryBackground: Container(
                          child: Center(child: Text("Deleted", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey))),
                        ),
                      ),
                    );
                  },
                );
              }
              else {
                print("snapshot is : ${snapshot}");
                return Center(
                  child: Text("Something went wrong !!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
