import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});
  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final mail = TextEditingController();

  final pass = TextEditingController();

  final name = TextEditingController();

  final formkey = GlobalKey<FormState>();

  String error_message = "";

  Future add_user() async {
    final db = FirebaseFirestore.instance;
    final pref = await SharedPreferences.getInstance();
    QuerySnapshot data = await db
        .collection("user_data")
        .where("mail", isEqualTo: mail.text)
        .get();

    if (data.docs.isNotEmpty) {
      setState(() {
        error_message = "** Mail Already exist **";
      });
    } else {
      db.collection("user_data").add({
        "mail": mail.text,
        "name": name.text,
        "password": pass.text
      }).then((value) {
        pref.setString("mail", mail.text);
        pref.setString("pass", pass.text);
        pref.setString("name", name.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const homepage()));
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/images/bk.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.2),
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign_up",
                      style:  TextStyle(
                          color: Colors.black38,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    //  SizedBox(height: 10,),
                    Container(
                      height: 230,
                      width: 230,
                      margin: const EdgeInsets.all(10),
                      decoration: const  BoxDecoration(
                          image:  DecorationImage(
                              image: AssetImage(
                                  "./Assets/images/panda-cooking.png"),
                              fit: BoxFit.cover)),
                    ),

                    // error message if user exists

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
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black45),
                              ),
                            )
                          : Container(),
                    ),

                    inp_box(text: "email", control: mail),
                    inp_box(text: "name", control: name),
                    inp_box(text: "password", control: pass),

                    Container(
                      height: 50,
                      width: 150,
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: (){
                          if (formkey.currentState!.validate()) {
                            add_user();
                          }
                        },
                        child: const Text("Create"),
                      ),
                    ),

                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const login_page()));
                        },
                        child: const Text("Already exist account"))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class inp_box extends StatelessWidget {
  final String text;
  final control;

  const inp_box({required this.text, required this.control,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: control,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "* fill the box  *";
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: text,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
