import 'dart:async';
import 'package:chature_1/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class flashscreen extends StatefulWidget{
  const flashscreen({super.key});

  @override
  State<flashscreen> createState() => _flashscreenState();
}

class _flashscreenState extends State<flashscreen> {
  String mail="";
  fetch_values()async{
      final pref=await SharedPreferences.getInstance();
      if(pref.containsKey("mail")){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const homepage()));
      }
      else{
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const login_page()));
      }
  }
  
  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 3),(){

          fetch_values();

    });
  }
  @override
  Widget build(BuildContext context) {
       return(
           Scaffold(
             body: Container(
                 alignment: Alignment.bottomCenter,
                 decoration: const BoxDecoration(
                   image: DecorationImage(image: AssetImage("./Assets/images/flashimage.png"), fit: BoxFit.cover,alignment: Alignment.center ),

                 ),

                 child:Container(
                   margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),

                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     //crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Expanded(child: Container()),
                       const Text("Chature",style: TextStyle(fontSize: 50, fontFamily: "flash",color: Colors.white),)
                       ,

                       Container(
                         margin: const EdgeInsets.fromLTRB(30, 10, 30, 100),
                         child: LinearProgressIndicator(
                           backgroundColor: Colors.deepOrange,
                           minHeight: 10,
                           color: Colors.yellow,
                           borderRadius: BorderRadius.circular(20),

                         ),

                       ),
                     ],
                   ),
                 )

             ),
           )
       );
  }
}