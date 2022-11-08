import 'package:arishti_task/models/Model.dart';
import 'package:arishti_task/api/FetchData.dart';
import 'package:firebase_database/firebase_database.dart';

class RTDB {

  // Insert data in Firebase real time DB
  static Future<void> insertData() async {
    final data = await API.FetchData();

    // print("data from api : ${data}");

    for (int i = 0; i < data["products"].length; i++) {
      String id = data["products"][i]["id"].toString();
      String title = data["products"][i]["title"].toString();
      String description = data["products"][i]["description"].toString();
      String brand = data["products"][i]["brand"].toString();
      String thumbnailUrl = data["products"][i]["thumbnail"].toString();

      await FirebaseDatabase.instance
          .ref()
          .child('products')
          .child("id${id}")
          .update({
        "id": id,
        "title": title,
        "brand": brand,
        "description": description,
        "thumbnailUrl": thumbnailUrl,
      });
    }
  }

  // fetch product data from Firebase Real time DB
  static Future<List<Model>> getData() async {
    List<Model> data = [];
    try {
      // fetch the data from real time database
      Query query1 = await FirebaseDatabase.instance.ref().child('products');

      // printing the queried data which have been fetched from real time database
      DataSnapshot event1 = await query1.get();

      // print("event value is : ${event.value}");

      if (event1.value == null) await insertData();

      // fetch data again after inserting
      Query query2 = await FirebaseDatabase.instance.ref().child('products');
      DataSnapshot event2 = await query2.get();

      // print("event value type is : ${event2.value.runtimeType}");
      // print("event value is : ${event2.value}");

      final fetchedData = event2.value! as Map;

      // print("fetched data : ${fetchedData}");
      // print("length of fetched data: ${fetchedData.length}");

      fetchedData.forEach((key, value) {
        data.add(Model(
            id: value["id"],
            title: value["title"],
            description: value["description"],
            brand: value["brand"],
            thumbnailUrl: value["thumbnailUrl"]));
      });

      return data;
    } catch (e) {
      print(e);
    }

    return data;
  }

  // insert archive data
  static Future<void> insertArchiveData(Model modelData) async {
    await deleteData(modelData);

    await FirebaseDatabase.instance
        .ref()
        .child('archive')
        .child("id${modelData.id}")
        .update({
      "id": modelData.id,
      "title": modelData.title,
      "brand": modelData.brand,
      "description": modelData.description,
      "thumbnailUrl": modelData.thumbnailUrl,
    });
  }

  // Delete the data from Firebase Real time DB
  static Future<void> deleteData(Model modelData) async {
    // print("ID to be deleted : ${modelData.id}");
    await FirebaseDatabase.instance
        .ref()
        .child('products')
        .child("id${modelData.id}")
        .remove();
  }

  // fetch the archieved the data
  static Future<List<Model>> getArchiveData() async {
    List<Model> data = [];
    try {
      // fetch the data from real time database
      Query query = await FirebaseDatabase.instance.ref().child('archive');

      // printing the queried data which have been fetched from real time database
      DataSnapshot event = await query.get();

      // print("event value is : ${event.value}");

      if (event.value == null) return data;

      final fetchedData = event.value! as Map;

      // print("fetched data : ${fetchedData}");
      // print("length of fetched data: ${fetchedData.length}");

      fetchedData.forEach((key, value) {
        data.add(Model(
            id: value["id"],
            title: value["title"],
            description: value["description"],
            brand: value["brand"],
            thumbnailUrl: value["thumbnailUrl"]));
      });

      return data;
    } catch (e) {
      print(e);
    }

    return data;
  }
}
