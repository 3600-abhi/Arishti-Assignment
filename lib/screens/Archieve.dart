import 'package:arishti_task/models/Model.dart';
import 'package:arishti_task/services/RTDB.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class Archieve extends StatefulWidget {
   Archieve({Key? key}) : super(key: key);

  @override
  State<Archieve> createState() => _ArchieveState();
}

class _ArchieveState extends State<Archieve> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for preventing the screenshots
    ScreenProtector.preventScreenshotOn();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Archive"),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<Model>>(
            future: RTDB.getArchiveData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Please wait loading...", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.teal),),
                );
              }
              else if(snapshot.hasData) {
                if(snapshot.data!.length  == 0) {
                  return Center(
                    child: Text("Data not found", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey),),
                  );
                }
                else return ListView.builder(
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
                        background: Container(color: Colors.tealAccent),
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
