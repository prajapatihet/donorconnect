import 'package:donorconnect/views/pages/donate/widgets/donate_screen_tabbar.dart';
import 'package:flutter/material.dart';

class DonateScreen extends StatelessWidget{
  const DonateScreen({super.key});
@override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar:AppBar(
      title: Center(child: Text('Donate',style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),)),
    ) ,
    body:
    const DonateScreenTabbar(),
    
    
  );
  }

}