import 'package:flutter/material.dart';

class module_work extends StatefulWidget {
  const module_work({super.key});

  @override
  State<module_work> createState() => _module_workState();
}

class _module_workState extends State<module_work> {
  
  String msg="abc";

  callback(x){
      setState(() {
            msg=x;
      });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
              child: Column(
                  children: [
                      disp(msg),
                      btn(()=>callback("hi")),
                      
                  ],
              ),
          ),
        ),
    );
  }
}






class disp extends StatelessWidget {

  String val;
  disp(this.val);


  @override
  Widget build(BuildContext context) {
    return  Text(val);
  }
}




class btn extends StatelessWidget {
  final VoidCallback onPressed;

  btn(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(onPressed: onPressed, child: Text("click me "));
  }
}

