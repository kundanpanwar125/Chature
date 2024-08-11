
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class test extends StatelessWidget {
  const test({super.key});

  add_data()async{

     final db= await FirebaseFirestore.instance;
     // db.collection("tmp").add({"name":"kundan","pass":"1234","fav":[{"id":"101","img":"kjdhfjkdh","name":"img1"}]}).then((value){
     //     print("data is added");
     // });
     await db.collection("tmp").where("name",isEqualTo: "kundan").get().then((value){
           db.collection("tmp").doc(value.docs[0].id).update({"fav":FieldValue.arrayUnion([{"id":"1022","name":"im1g22","img":"hj5jfhgfghf"}])}).then((value){
               print("value is added");
           });
     });
  }




  @override
  Widget build(BuildContext context) {
    add_data();
    return Scaffold();
  }
}
