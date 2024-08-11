import 'package:chature_1/recipe_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_widgets.dart';
import 'package:flutter/material.dart';
class favourite extends StatefulWidget {
  const favourite({super.key});

  @override
  State<favourite> createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {

  List fav_list=[];
  IconData i=Icons.favorite_border_rounded;
  String mail="";

  Future<void> get_fav() async {
    final pref =await SharedPreferences.getInstance() ;
    mail =pref.getString("mail") as String;
    List tmp=[];
    try {
      final db = await FirebaseFirestore.instance;
      QuerySnapshot fetch_data= await db.collection("user_data").where("mail",isEqualTo: mail ).get();
      tmp=fetch_data.docs[0]["fav"];
      setState(() {
         fav_list=tmp;
         get_fav();
      });

    } catch (e) {
      print('Error adding document: $e');
    }
  }

  del_fav(id,name,img)async{
    try {
      final db = await FirebaseFirestore.instance;
      await db.collection("user_data").where("mail",isEqualTo: mail).get().then((value){
           db.collection("user_data").doc(value.docs[0].id).update({"fav": FieldValue.arrayRemove([{"id":id,"name":name,"img":img}])}).then((value){
                print("value is deleted");
                get_fav();
           });
      });

    } catch (e) {
      print('Error adding document: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_fav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
        ),
       body: Container(
           child: Column(
              children: [
                 Expanded(
                     flex: 1,
                     child: custom_banner(heading:"Favourite Recipes",)),

                // Container(
                //   height: 130,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(image: AssetImage("./Assets/images/banner1.png"),fit:BoxFit.cover),
                //   ),
                //   alignment: Alignment.center,
                // ),
                // Container(
                //   height: 10,
                //   decoration: BoxDecoration(
                //     // border:Border.all(color: Colors.black),
                //       boxShadow: [BoxShadow(
                //         color: Colors.white,
                //         spreadRadius: 18,
                //         blurRadius: 10,
                //       )]
                //   ),
                // ),

               // page heading
              //  custom_heading(value: "Favourite Items"),


                Expanded(
                  flex: 4,
                  child: Container(
                  width:MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.8,
                  padding: EdgeInsets.all(10),
                  child: fav_list.length>0 ? Container(
                    // searched itme design
                    child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context,index){
                      return Container(
                        // padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 3,blurRadius:5)],
                        ),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>recipe_content(id: fav_list[index]["id"])));

                          },
                          child: Column(
                            children: [
                              // image
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(fav_list[index]["img"]),fit: BoxFit.cover),
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                  )
                                  ,

                                ),
                              ),
                              // recipe name
                              Expanded(
                                flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    //  color: Colors.yellowAccent,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex:4,
                                            child:Container(
                                              // color: Colors.blueAccent,
                                              alignment: Alignment.center,
                                              child: Text(fav_list[index]["name"],
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width*0.035,
                                                ),
                                              ),
                                            )
                                        ),

                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.center,
                                              // color: Colors.pink,
                                              child: IconButton(
                                                onPressed: (){
                                                  del_fav(fav_list[index]["id"],fav_list[index]["name"],fav_list[index]["img"]);
                                                  get_fav();
                                                },
                                                icon: Icon(Icons.delete_forever,color: Colors.red,size: MediaQuery.of(context).size.width*0.06,),
                                              ),
                                            )),
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },itemCount: fav_list.length,),

                  ):Center(child: Text("Nothing to show ")),
                ),)
              ],
           ),
       ),
       bottomNavigationBar: navbar(),
    );
  }
}
