import 'package:flutter/material.dart';
import 'home.dart';
import 'package:hive/hive.dart';

class GetName extends StatefulWidget {
  @override
  _GetNameState createState() => _GetNameState();
}

class _GetNameState extends State<GetName> with SingleTickerProviderStateMixin{

  static String name;
  var box;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    box = Hive.box('name');
    animationController = AnimationController(duration: Duration(seconds:1), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  @override
  dispose() {
    super.dispose();
    animationController.dispose();
  }

  TextEditingController nameController = TextEditingController();
  var key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return Transform(
          transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
          child: Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/undraw_adventure_4hum.png'),
                      fit: BoxFit.contain,
                      )
                  ),
                ),
                ),
                Text(
                  'Hey boss\nHow may I address you?',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blueGrey[900],
                    decoration: TextDecoration.none
                  ),
                ),
                SizedBox(height: 10,),
                Form(
                  key: key,
                  child: TextFormField(
                    controller: nameController,
                    validator: (String name){
                      if (name.isEmpty){
                        return 'I really need to know';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Your name or nickname',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child:FlatButton(
                  color: Theme.of(context).primaryColorLight,
                  onPressed: (){
                    if(key.currentState.validate()){
                      setState(() {
                        name = nameController.text;
                        box.put(0, name);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return Home();
      }));
                      });
                    }
                    }, 
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.lightBlueAccent
                    ),
                  ),
                  ))
            ],),
        ),
      ))

        );
      },
    );
     
  }
}
