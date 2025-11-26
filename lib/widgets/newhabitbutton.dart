
import 'package:flutter/material.dart';
import 'package:track/theme/colors.dart';

class NewHabitButton extends StatelessWidget {
  BuildContext Context;
  final Function()? onTap;
   NewHabitButton({
    super.key,
    required this.Context,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap:onTap,
      child: Container(
       
       decoration: BoxDecoration(
         color: Theme.of(Context).brightness == Brightness.light? AppColors.greylight : AppColors.greydark,
         borderRadius: BorderRadius.circular(8),
         //border: Border.all(color: AppColors.greenprimary.withOpacity(0.5),width: 1.5)
         ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:4.0, horizontal:6),
          child: Row(
           
           children: [
           Text("New habit",style: TextStyle(fontFamily:"schibstedGrotesk",fontSize: 14, fontWeight: FontWeight.w600),),
           SizedBox(width:4),
           Icon(Icons.add,size:24,color:AppColors.greenprimary,weight: 3,),
          ],),
        ),
      ),
    );
  }
}
