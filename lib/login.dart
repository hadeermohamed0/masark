// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
class login extends StatelessWidget {
  var emailcontroller =TextEditingController();
  var passcontroller =TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent ,),
      body:Padding(
        padding:  EdgeInsets.all(20  ),
        child:Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
                 Text(
                   'LOGIN',
                   style: TextStyle(
                     fontSize:30,
                     fontWeight:FontWeight.bold
                   ),
          
                 ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailcontroller,
                  onFieldSubmitted: (String value){
          
                    print(value);
                   },
                  onChanged: (String value){
                    print(value);
                  },
                  keyboardType: TextInputType.emailAddress,
          
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'USER NAME',
                      border: OutlineInputBorder(),
          
                    ),
          
          
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passcontroller,
                  // onFieldSubmitted: (String value){
                  //
                  //   print(value);
                  // },
                  // onChanged: (String value){
                  //   print(value);
                  // },
                  keyboardType: TextInputType.visiblePassword,obscureText: true ,
          
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock ),
                    labelText: 'PASSWORD ',
                    border: OutlineInputBorder(),
          
                  ),
          
          
          
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                   color: Colors.blue,
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: () {
                      print(emailcontroller.text);
                      print(passcontroller.text);
                    },
                      child:Text('Start',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                  ),
                ) ,
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont\'t have an account?'),
                    TextButton(onPressed: (){},
                      child: Text(
                      'Register Now',
          
                    ),
                    ),
                  ],
                )
          
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}


