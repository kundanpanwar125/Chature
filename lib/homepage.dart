import 'dart:convert';

import 'package:chature_1/profile.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chature_1/search.dart';
import 'api_work.dart';
import 'custom_widgets.dart';
import 'package:flutter/material.dart';
import 'app_content_values.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  bool imgloader = true;
  final api = food_api();
  String username="";
  // List<dynamic> random_recipe_list = [];
  List<dynamic> category=[];


   user ()async{
     final pref = await SharedPreferences.getInstance();
     String u= pref.getString("user")as String;
     print(u);
   }


   getGreeting() {
    final hour = DateTime.now().hour;
    print(hour);
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }

  }

  fetch_data()async{
    final pref =await SharedPreferences.getInstance();
    if(pref.containsKey("mail")){
      setState(() {
        username=pref.get("name")as String;
      });

    }
  }

  fetch_ctg()async{
    category=await api.category_list();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetch_ctg();
    fetch_data();
  }

  // Future<void> fetchRandomRecipes() async {
  //   random_recipe_list = await api.random_recipe();
  //
  //   Timer(Duration(milliseconds: 2000), () {
  //     setState(() {
  //       if (random_recipe_list.isNotEmpty) {
  //         imgloader = false;
  //       }
  //     });
  //   });
  // }


  List cate_list = category_values;

  var search_value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    user();
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      // main body of the page
      body: SingleChildScrollView(
        child: Container(
          // margin: EdgeInsets.all(10),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //  border:Border.all(color: Colors.black)
          ),
          alignment: Alignment.center,
          child: Column(
            children: [

              // page search bar with backgound image
              search_bar(getdata: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    search_recipe(val: search_value.text,)));
              }, search_controller: search_value,),


              SizedBox(height: 15,),

              // greeting message
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text("${getGreeting()} , ${username.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // food Category menu bar design
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 80,
                  width: 565,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>search_recipe(ctg_search:category[index]["strCategory"],)));
                        },
                        child: Container(
                          width: 150,
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              )
                              ]
                          ),
                          child: Text("${category[index]["strCategory"]}"),
                        ),
                      ),
                    );
                  },
                    itemCount: category.length,
                    scrollDirection: Axis.horizontal,

                  )


              ),

              // Headin  of new section , discover recipes

              Container(
                margin: EdgeInsets.only(bottom: 20, top: 15),
                padding: EdgeInsets.only(left: 20,),
                alignment: Alignment.centerLeft,
                child: Text("Discover recipes,",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // discover section

              Container(
                  height: 300,
                  width: 565,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return random_recipe();
                  },
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,

                  )


              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: navbar(),
    );
  }

}



