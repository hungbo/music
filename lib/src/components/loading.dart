import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.black54,
        // width: 150.0,
        // height: 150.0,
        child: const SpinKitHourGlass(
      color: Colors.black,
      size: 50.0,
    )
        //  SpinKitFadingCircle(
        //   itemBuilder: (_, int index) {
        //     return DecoratedBox(
        //       decoration: BoxDecoration(
        //         color: index.isEven ? Colors.red : Colors.green,
        //       ),
        //     );
        //   },
        //   size: 120.0,
        // ),
        );
  }
}
