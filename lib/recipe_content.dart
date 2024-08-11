import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:chature_1/api_work.dart';
import 'package:chature_1/custom_widgets.dart';
import 'package:flutter/material.dart';

class recipe_content extends StatefulWidget {
  final id;

  const recipe_content({required this.id, super.key});

  @override
  State<recipe_content> createState() => _recipe_contentState();
}

class _recipe_contentState extends State<recipe_content> {
  List<dynamic> data = [];
  final api = food_api();
  bool img_loader = true;

  fetch_data() async {
    data = await api.search_by_id(widget.id);
      setState(() {
        img_loader = false;
    });
  }

  void url() async {
    var urlstring = data[0]["strYoutube"];
    var url = Uri.parse(urlstring);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(data[0]["strYoutube"]);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
        // leading: IconButton(
        //   icon:Icon(Icons.arrow_back),
        //   onPressed: (){
        //      Navigator.pop(context);
        //   },
        // ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            // custom_banner(
            //   heading: " ",
            //   title: false,
            // ),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // recipe image
                    Expanded(
                        flex: 4,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                              image: img_loader
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          "Assets/images/loader2.gif"),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image:
                                          NetworkImage(data[0]["strMealThumb"]),
                                      fit: BoxFit.cover),
                              border: const BorderDirectional(
                                  bottom: BorderSide(
                                      color: Colors.black26, width: 2)),
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(10),
                              color: Colors.black38,
                              child: Text(
                                img_loader
                                    ? "Loading ...."
                                    : data[0]["strMeal"],
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        )),
                    // recipe content
                    Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("Assets/images/bk.jpg"),
                                fit: BoxFit.cover,
                                opacity: 0.3),
                            color: Colors.white,
                            //borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20))
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              const Text(
                                "Recipe",
                                style: TextStyle(fontSize: 30),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  _launchUrl();
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.black12,
                                    child: Text(
                                      data.isNotEmpty
                                          ? "Youtube video link : ${data[0]["strYoutube"]}"
                                          : "loading....",
                                      style: const TextStyle(
                                          color: Colors.deepPurpleAccent),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(data.isNotEmpty
                                  ? data[0]["strInstructions"]
                                  : "loading..."),
                            ],
                          ),
                        ))
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: const navbar(),
    );
  }
}
