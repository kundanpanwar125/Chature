import 'dart:async';

import 'package:chature_1/recipe_content.dart';

import 'api_work.dart';
import 'favourite.dart';
import 'homepage.dart';
import 'search.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

// custom banner

class custom_banner extends StatelessWidget {
  custom_banner({required this.heading, this.title=true});
  bool title=true;

  String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 130,
      decoration: BoxDecoration(
        //  border:Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage("./Assets/images/search_img.jpg"),
            fit: BoxFit.cover),
      ),
      alignment: Alignment.center,
      child: title ? custom_heading(
        value: heading,
      ): Container(),
    );
  }
}

// navigation bar of the app

class navbar extends StatelessWidget {
  const navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 70,
      destinations: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => homepage()));
          },
          icon: Icon(Icons.home),
          style: ButtonStyle(),
          tooltip: "home",
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => favourite()));
            },
            icon: Icon(Icons.favorite),
            tooltip: "favorite"),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => search_recipe()));
            },
            icon: Icon(Icons.search),
            tooltip: "search"),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => profile_page()));
            },
            icon: Icon(Icons.person),
            tooltip: "profile"),
      ],
    );
  }
}

// search bar of the page

class search_bar extends StatelessWidget {
  bool ontextchange = false;
  var search_controller = TextEditingController();

  search_bar(
      {required this.getdata,
      required this.search_controller,
      this.ontextchange = false});

  VoidCallback getdata;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              //  border:Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),

              image: DecorationImage(
                  image: AssetImage("./Assets/images/search_img.jpg"),
                  fit: BoxFit.cover),
            ),
            alignment: Alignment.center,
            child: Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: TextField(
                  onChanged: (value) {
                    getdata();
                  },
                  controller: search_controller,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          getdata();
                        },
                        icon: Icon(Icons.search),
                      ),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ))),
            ),
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(
                // border:Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 18,
                    blurRadius: 10,
                  )
                ]),
          ),
        ],
      ),
    );
  }
}

class custom_block extends StatelessWidget {
  String name = "";
  var s = 20.0;

  custom_block({this.name = "", this.s = 20.0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Text(name, style: TextStyle(fontSize: s)),
          alignment: Alignment.center,
        ));
  }
}

class custom_inp extends StatelessWidget {
  final control ;
  final bool enabel;
  custom_inp({required this.control,this.enabel=false});


  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          child: TextFormField(
            enabled: enabel,
            controller: control,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "* fill the box  *";
              }
              return null;
            },
            decoration: InputDecoration(
                  fillColor:Colors.black ,
                  disabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ));
  }
}

class custom_heading extends StatelessWidget {
  String value = "";

  custom_heading({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 5)
        ],
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class random_recipe extends StatefulWidget {
  const random_recipe({super.key});

  @override
  State<random_recipe> createState() => _random_recipeState();
}

class _random_recipeState extends State<random_recipe> {

  List<dynamic> random_recipe_data=[];
  bool imgloader = true;
  final api = food_api();

  set_data()async{
      random_recipe_data=await api.random();
      Timer(Duration(milliseconds: 2000),(){
        setState(() {
          if(random_recipe_data.isNotEmpty){
            imgloader=false;
          }
        });
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    set_data();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>recipe_content(id: random_recipe_data[0]["idMeal"])));
        },
        child: Container(
            width: 180,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                color: Colors.white,
                image: imgloader
                    ? DecorationImage(
                        image: AssetImage("Assets/images/loader2.gif"),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(
                            random_recipe_data[0]["strMealThumb"]),
                        fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  )
                ]),
            child: Container(
                    height: 40,
                    width: 200,
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      random_recipe_data.isNotEmpty? random_recipe_data[0]["strMeal"]:"Loading.....",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                 ),
      ),
    );
  }
}
