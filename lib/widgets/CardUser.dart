// import 'dart:math';
// import 'package:bloctest/bloc/user/user_bloc.dart';
// import 'package:bloctest/models/user_model.dart';
// import 'package:bloctest/pages/user_form_screen.dart';
// import 'package:bloctest/widgets/SlideRightRoute.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CardUser extends StatelessWidget {
//   const CardUser({
//     super.key,
//     required this.user,
//   });

//   final User user;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 7,
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             splashFactory: InkRipple.splashFactory,
//             onTap: () {
//               if (kDebugMode) {
//                 print('User: ${user.name}');
//               }
//               Navigator.push(
//                 context,
//                 SlideRightRoute(
//                   page: BlocProvider.value(
//                     value: BlocProvider.of<UserBloc>(context),
//                     child: UserFormScreen(user: user),
//                   ),
//                 ),
//               );
//             },
//             borderRadius: BorderRadius.circular(
//                 10), // Match the Container's border radius
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 70,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(100),
//                       gradient: LinearGradient(
//                         colors: [getRandomColor(), getRandomColor()],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     child: Text(
//                       '${user.name.split(' ').first[0]}${user.name.split(' ').last[0]}',
//                       style: const TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.name,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         user.email,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Color getRandomColor() {
//     final random = Random();
//     return Color.fromRGBO(
//       random.nextInt(256),
//       random.nextInt(256),
//       random.nextInt(256),
//       1,
//     );
//   }
// }
