import 'package:flutter/material.dart';
import 'package:track/theme/colors.dart';
import 'package:track/widgets/nextbutton.dart';

class FirstHabit extends StatefulWidget {
  const FirstHabit({super.key});

  @override
  State<FirstHabit> createState() => _FirstHabitState();
}

class _FirstHabitState extends State<FirstHabit> {
  TextEditingController firsthabit = TextEditingController();
  bool showError = false; // 👈 add this

  void validateField() {
    setState(() {
      showError = firsthabit.text.trim().isEmpty; // 👈 show error when empty
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height:50),
            Row(
              mainAxisAlignment: .center,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text("Add your  ",style: TextStyle(fontFamily:"schibstedGrotesk",fontSize: 24,fontWeight: FontWeight.w600),),
                Image(image:AssetImage("assets/first.png"),height:40),
                Text("   First Habit",style:TextStyle(fontFamily:"schibstedGrotesk",fontSize: 24,fontWeight: FontWeight.w600),),
              ],
            ),
            SizedBox(height:8),
            Text("What is the first habit you want to track?",style: TextStyle(fontFamily:"schibstedGrotesk",fontSize: 12,color: Colors.grey),),
            SizedBox(height:30),
            TextField(
              controller: firsthabit,
              
              decoration: InputDecoration(
                focusColor: AppColors.green2.withOpacity(0.2),
                hintText: "Eg: Drink Water",
                hintStyle: TextStyle(fontFamily:"schibstedGrotesk",fontSize: 14,color: Colors.grey.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  )
                ),
                focusedBorder: OutlineInputBorder(
               
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.green2.withOpacity(  0.5),
                  )
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                ),



                errorText: showError ? "Please enter a habit" : null, // 👈 show error text
              ),
            ),
            Spacer(),
            Center(child: NextButton(pressed:(){

              validateField();
              if(!showError){
                // Proceed to next step
              }
            })),
            SizedBox(height:20,)
        
          ],
        ),
      ),
    );
  }
}