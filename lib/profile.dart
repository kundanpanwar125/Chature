import 'package:chature_1/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class profile_page extends StatefulWidget {
  const profile_page({super.key});
  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {

  bool enabel=false;
  String btn_text="Edit";

  final name=TextEditingController();
  final  pass=TextEditingController();
  final mail=TextEditingController();

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch_data();
  }

  update_data()async{
      final pref=await SharedPreferences.getInstance();
      final db= FirebaseFirestore.instance;
      db.collection("user_data").where("mail",isEqualTo: mail.text).get().then((value){
            db.collection("user_data").doc(value.docs[0].id).update({"name":name.text,"password":pass.text}).then((value){
                pref.setString("pass", pass.text);
                pref.setString("name",name.text);
                setState(() {
                   btn_text="Edit";
                   enabel=false;
                });
            });

      });
  }
  
  fetch_data()async{
     final pref =await SharedPreferences.getInstance();
     if(pref.containsKey("mail")){
          name.text=pref.get("name")as String;
          pass.text=pref.get("pass")as String;
          mail.text=pref.get("mail")as String;
     }
  }

  reset_pref()async{
    final pref =await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.85,
             child: Form(
               key: formkey,
               child: Column(

                 children: [
                   // page heading
                   custom_banner(heading: "Account page",),

                   //  input  form for user
                   Expanded(
                     flex: 3,
                     child: Container(
                        margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 30),
                        padding: const EdgeInsets.all(10),
                        width: 500,
                        decoration: BoxDecoration(
                            image: const DecorationImage(image: AssetImage("Assets/images/bk.jpg"),fit:BoxFit.cover,opacity: 0.2),
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.white,
                           boxShadow: const [BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 5,
                              blurRadius: 5
                           )],
                        ),

                       child: Row(
                           children: [

                             // titles
                             Expanded(
                                 flex: 1,
                                 child:Column(
                                     children: [
                                         custom_block(name:"Name"),
                                         custom_block(name:"Email"),
                                         custom_block(name:"password"),
                                     ],
                                 )),

                             // input fields
                             Expanded(
                                 flex :2,
                                 child:Column(
                                   children: [
                                     custom_inp(control: name,enabel: enabel,),
                                     custom_inp(control: mail),
                                     custom_inp(control: pass,enabel: enabel),
                                   ],
                                 )),

                           ],
                       ),
                     ),
                   ),

                   Expanded(
                      flex: 1,
                      child: Container(
                         alignment: Alignment.center,
                         padding: const EdgeInsets.only(bottom: 20),
                       //  color: Colors.greenAccent,
                         child:Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             // edit and submit button
                             Container(
                               height: 50,
                               width: 150,
                               margin:const EdgeInsets.only(right: 30),
                               child: ElevatedButton(
                                 onPressed: (){
                                    if(btn_text=="Edit"){
                                      setState(() {
                                        enabel=true;
                                        btn_text="Submit";
                                      });
                                    }
                                    else{
                                        formkey.currentState!.validate();
                                        update_data();
                                    }

                                 },
                                 child: Text(btn_text,style: const TextStyle(fontSize: 20),),
                               ),
                             ),
                           // logout button
                             Container(
                               height: 50,
                               width: 150,
                               child: ElevatedButton(
                                 onPressed: (){
                                      reset_pref();
                                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const login_page()));
                                 },
                                 child: const  Text("logout",style: TextStyle(fontSize: 20),),
                               ),
                             )
                           ],
                         )
                      ),
                   )
                 ],
               ),
             ),
          ),
        ),
        bottomNavigationBar: const navbar(),
    );
  }
}
