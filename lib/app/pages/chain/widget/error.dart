import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  CustomErrorWidget({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ExpandablePanel(
      header: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50.0,
          ),
          Text(
            'An error occurred!',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      collapsed: SizedBox(),
      expanded: Column(
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ));
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             color: Colors.red,
//             size: 50.0,
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             'Error Occurred!',
//             style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             errorMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 16.0),
//           ),
//         ],
//       ),
//     );
//   }
// }


