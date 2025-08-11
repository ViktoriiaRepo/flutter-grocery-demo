import 'package:flutter/material.dart';

class FirstStateFull extends StatefulWidget {
  final int startCount;

  const FirstStateFull({super.key, required this.startCount});

  @override
  State<FirstStateFull> createState() => _FirstStateFullState();
}

class _FirstStateFullState extends State<FirstStateFull> {
  int count = 0;
  @override
  void initState() {
    count= widget.startCount;
    super.initState();
  }

  // @override
  // void dispose() {
  //   
  //   super.dispose();
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   
  //   super.didChangeDependencies();
  // }

  // @override
  // void didUpdateWidget(covariant FirstStateFull oldWidget) {
  //  
  //   super.didUpdateWidget(oldWidget);
  //   if(widget.startCount != oldWidget.startCount) {
  //     setState(() {
  //       count = widget.startCount;
  //     });
  //   }
  // }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Count is $count", style: TextStyle(
        fontSize: 18,
        ),),
        FilledButton(onPressed: (){
          setState(() {
            count++;
          });
        },
            child: Text("Filled Button")
        ),

        
      ]
    );
  }
}
