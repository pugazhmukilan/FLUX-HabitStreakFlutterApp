import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:track/local_storage_repository.dart';
import 'package:track/screens/firsthabit.dart';
import 'package:track/theme/colors.dart';
import 'package:track/widgets/nextbutton.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({super.key});

  @override
  State<welcomePage> createState() => _welcomePageState();
}

class _welcomePageState extends State<welcomePage> {
  
  @override
  
  Widget build(BuildContext context) {
    
  
    return Scaffold(
      
      body:Stack(
        children:[ 
          Positioned(
            bottom:20,
            left:20,
            child:Container(
              width:150,
              height:150,
              decoration:BoxDecoration(
                color:Colors.green.withOpacity(0.2)
              )
            )
          ),
          Positioned(
            right:20,
            top:20,
            child:Container(
              width:150,
              height:150,
              decoration:BoxDecoration(
                color:Colors.green.withOpacity(0.2)
              )
            )
          ),
          Positioned(child: BackdropFilter(
            filter:  ui.ImageFilter.blur(sigmaX: 80,sigmaY: 80),
          child: Container())),
          
          
          
          Column(
            crossAxisAlignment: .start,
            
          children: [
            SizedBox(height: 60,),
            
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Image(image: Theme.of(context).brightness ==Brightness.light ?    AssetImage("assets/welcomelight.png"):AssetImage("assets/welcomedark.png"), width: 300),
            ),
            Spacer(),
          
            Center(child: NextButton(pressed:(){

              LocalStorageRepository.setBool("newuser",false).then((value) {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>FirstHabit()));
              
  }
              );
              })),
            SizedBox(height: 30)
          ],
                  ),
        
        
        
        ]
      )
    );
  }
}

