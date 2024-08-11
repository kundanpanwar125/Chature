import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class food_api {

  String api_url = "https://www.themealdb.com/api/json/v1/1/";

  Future<List> search(val) async {
    try {
      final response = await http.get(Uri.parse("${api_url}search.php?s=$val"));
      if (response.statusCode == 200) {
        final f = jsonDecode(response.body);
        List<dynamic> data = f["meals"] as List<dynamic>;
        return data;
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error 101 : $error');
    }
    return [];
  }

  Future<List> category_list() async {
    try {
      final response = await http.get(Uri.parse("${api_url}list.php?c=list"));
      if (response.statusCode == 200) {
        final f = jsonDecode(response.body);
        List<dynamic> data = f["meals"] as List<dynamic>;
        return data;
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error 101 : $error');
    }
    return [];
  }



  // Future<List> random_recipe() async {
  //   const List ctg=["Beef","Dessert","Miscellaneous","Pasta","Seafood","Starter","Vegan","Breakfast"];
  //   final random=Random();
  //   var index=random.nextInt(ctg.length);
  //
  //   try {
  //     final response = await http.get(Uri.parse("${api_url}filter.php?c=${ctg[index]}"));
  //     if (response.statusCode == 200) {
  //       final f = jsonDecode(response.body);
  //       List<dynamic> data = f["meals"] as List<dynamic>;
  //       return data;
  //     } else {
  //       // Handle error (e.g., show a snackbar)
  //       print('Error fetching data: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle network or other errors
  //     print('Error 101 : $error');
  //   }
  //   return [];
  // }

  Future<List> random() async {

    try {
      final response = await http.get(Uri.parse("${api_url}random.php"));
      if (response.statusCode == 200) {
        final f = jsonDecode(response.body);
        List<dynamic> data = f["meals"] as List<dynamic>;
        return data;
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error 101 : $error');
    }
    return [];
  }

  Future<List> search_by_id(id) async {

    try {
      final response = await http.get(Uri.parse("${api_url}lookup.php?i=$id"));
      if (response.statusCode == 200) {
        final f = jsonDecode(response.body);
        List<dynamic> data = f["meals"] as List<dynamic>;
        return data;
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error 101 : $error');
    }
    return [];
  }

  Future<List> search_by_ctg(ctg) async {

    try {
      final response = await http.get(Uri.parse("${api_url}filter.php?c=$ctg"));
      if (response.statusCode == 200) {
        final f = jsonDecode(response.body);
        print(ctg);
        print("s by ctg");
        List<dynamic> data = f["meals"] as List<dynamic>;

        print(data);
        return data;
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error 101 : $error');
    }
    return [];
  }




}


