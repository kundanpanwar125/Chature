import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  var mail = TextEditingController();
  var pass = TextEditingController();
  final login_form_key = GlobalKey<FormState>();
  String error_message ="";



  Future<List> fetch_user_data (val) async {
    List<Map> tmp=[];
    try {
      final db = FirebaseFirestore.instance;
      QuerySnapshot fetch_data= await db.collection("user_data").where("mail",isEqualTo: val).get();

        if(fetch_data.docs.isNotEmpty){
          tmp.add(fetch_data.docs[0].data() as Map);
          print(tmp);
          return tmp;
        }
        else{
          return [] ;
        }

    } catch (e) {
      print('Error adding document: $e');
      return [];
    }
  }

  login(user)async{
      final pref = await SharedPreferences.getInstance();
      List user_data=await fetch_user_data(user);
      if (user_data.isNotEmpty){

           if(pass.text==user_data[0]["password"]){
              pref.setString("mail", mail.text);
              pref.setString("pass", pass.text);
              pref.setString("name", user_data[0]["name"]);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const homepage()));
           }
           else{
              setState(() {
                  error_message="password is incorrect";
              });
           }
      }
      else{
          setState(() {
              error_message="email not exists";
          });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: 500,
            padding: const EdgeInsets.all(20),
            decoration:const BoxDecoration(
              image:  DecorationImage(
                  image:  AssetImage("Assets/images/bk.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.2),
            ),
            child: Form(
              key: login_form_key,
              autovalidateMode:AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),

                  Container(
                    height: 250,
                    width: 250,
                    margin: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                    decoration: const BoxDecoration(
                        // border: Border.all(color: Colors.black,),
                        image: DecorationImage(
                      image: AssetImage("./Assets/images/login_img.png"),
                      fit: BoxFit.cover,
                    )),
                  ),

                  Container(
                    child: error_message.isNotEmpty
                        ? Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,

                      ),
                      child: Text(
                        error_message,
                        style:
                        const TextStyle(fontSize: 20, color: Colors.black45),
                      ),
                    )
                        : Container(),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: mail,
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value){
                          if(value==null || value.isEmpty){
                              return "please enter username";
                          }
                          return null;

                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value){
                        if(value==null || value.isEmpty){
                          return "please enter password";
                        }
                        return null;

                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        style: const ButtonStyle(),
                        onPressed: () {

                           if(login_form_key.currentState!.validate()==true){
                               login(mail.text);
                               //print("username ${mail.text}  password ${pass.text}");
                           }

                        },
                        child: const Text("login")),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const sign_up()));
                      },
                      child: const Text("create new account"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
