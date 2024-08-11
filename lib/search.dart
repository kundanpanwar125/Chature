import 'package:chature_1/recipe_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'api_work.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class search_recipe extends StatefulWidget {
  var val;
  String? ctg_search = null;
  search_recipe({this.val = null, this.ctg_search});

  @override
  State<search_recipe> createState() => _search_recipeState();
}

class _search_recipeState extends State<search_recipe> {
  String mail = "";
  var search_value = TextEditingController();

  // api work
  List data = [];
  List fav_item = [];
  final api = food_api();
  IconData i = Icons.favorite_border_rounded;

  Future<void> set_fav(id, name, img) async {
    try {
      final db = FirebaseFirestore.instance;
      await db
          .collection("user_data")
          .where("mail", isEqualTo: mail)
          .get()
          .then((value) {
        db.collection("user_data").doc(value.docs[0].id).update({
          "fav": FieldValue.arrayUnion([
            {"id": id, "name": name, "img": img}
          ])
        }).then((value) {
          get_fav();
        });
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<void> get_fav() async {
    final pref = await SharedPreferences.getInstance();
    mail = pref.getString("mail") as String;
    List fav_list = [];
    try {
      final db = FirebaseFirestore.instance;
      QuerySnapshot fetch_data =
          await db.collection("user_data").where("mail", isEqualTo: mail).get();
      fav_list = fetch_data.docs[0]["fav"];
      List<String> idList =
          fav_list.map((item) => item['id'] as String).toList();
      setState(() {
        fav_item = idList;
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  del_fav(id, name, img) async {
    try {
      final db = await FirebaseFirestore.instance;
      await db
          .collection("user_data")
          .where("mail", isEqualTo: mail)
          .get()
          .then((value) {
        db.collection("user_data").doc(value.docs[0].id).update({
          "fav": FieldValue.arrayRemove([
            {"id": id, "name": name, "img": img}
          ])
        }).then((value) {
          print("value is deleted");
          get_fav();
        });
      });
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  void initState() {
    super.initState();
    var value = widget.val;
    if (value != null) {
      fetchData(value);
      search_value.text = value;
    } else {
      fetchData(widget.ctg_search);
      setState(() {});
      print("test");
    }
    get_fav();
  }

  fav_icon(val) {
    if (fav_item.contains(val)) {
      return true;
    } else {
      return false;
    }
  }

  void fetchData(val) async {
    List<dynamic> result = [];
    if (widget.ctg_search == null) {
      result = await api.search(val);
    } else {
      result = await api.search_by_ctg(val);
      print(result);
    }

    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              search_bar(
                getdata: () {
                  fetchData(search_value.text);
                },
                search_controller: search_value,
              ),

              // page heading
              custom_heading(value: "Recipes"),

              // search items list
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    // border: Border.all()
                    ),
                child: data.length > 0
                    ? Container(
                        // searched itme design
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>recipe_content(id: data[index]["idMeal"])));
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 3,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // image
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index]["strMealThumb"]),
                                                fit: BoxFit.cover),
                                            color: Colors.greenAccent,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
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
                                                  flex: 4,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    // color: Colors.blueAccent,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      data[index]["strMeal"],
                                                      style: TextStyle(
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    // color: Colors.pink,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        if (fav_icon(data[index]
                                                            ["idMeal"])) {
                                                          del_fav(
                                                              data[index]
                                                                  ["idMeal"],
                                                              data[index]
                                                                  ["strMeal"],
                                                              data[index][
                                                                  "strMealThumb"]);
                                                        } else {
                                                          set_fav(
                                                              data[index]
                                                                  ["idMeal"],
                                                              data[index]
                                                                  ["strMeal"],
                                                              data[index][
                                                                  "strMealThumb"]);
                                                        }

                                                        get_fav();
                                                      },
                                                      icon: fav_icon(data[index]
                                                              ["idMeal"])
                                                          ? Icon(
                                                              Icons.favorite,
                                                              color: Colors.pink,
                                                              size: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.06,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .favorite_border_rounded,
                                                              color: Colors.pink,
                                                              size: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.06,
                                                            ),
                                                    ),
                                                  )),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        ),
                      )
                    : Center(child: Text("Nothing to show ")),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: navbar(),
    );
  }
}
