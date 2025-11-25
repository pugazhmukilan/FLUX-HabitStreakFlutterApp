import 'package:flutter/material.dart';
import 'package:track/theme/colors.dart';

class NextButton extends StatelessWidget {
  Function()? pressed;
  NextButton({
    super.key,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        
        padding: .all(EdgeInsets.symmetric(vertical: 10,horizontal: 10)),
        fixedSize: .all(Size(300,70)),
        shape: .all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ))
        
      ),
      
      onPressed:pressed,
     child: Row(
          mainAxisAlignment: .center,
          children: [
            // Fixed width icon container
            Container(
              width: 60,
              decoration: BoxDecoration(
                color:Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(15)
              ),
              
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.arrow_forward_ios,size: 20),
              ),
            ),
    
            Expanded(
              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(fontFamily:"schibstedGrotesk",fontSize: 16),
                ),
              ),
            ),
    
            // Placeholder to balance the layout
            SizedBox(width: 30),
          ],
        ),
     );
  }
}