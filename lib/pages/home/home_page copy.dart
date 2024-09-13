// import 'package:bloctest/bloc/user/user_bloc.dart';
// import 'package:bloctest/bloc/visibility/visibility_bloc.dart';
// import 'package:bloctest/widgets/AnimatedVisibilityWidget.dart';
// import 'package:bloctest/widgets/CardIcon.dart';
// import 'package:bloctest/widgets/CardSkeleton.dart';
// import 'package:bloctest/widgets/CardUser.dart';
// import 'package:bloctest/widgets/CarouselCard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'user_form_screen.dart';

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ScrollController scrollController = ScrollController();
//     return Scaffold(
//       backgroundColor: const Color(0xFFE5E5E5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Colors.red, Colors.blue],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: Container(
//                             margin: const EdgeInsets.all(2),
//                             padding: const EdgeInsets.all(3),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.white,
//                               child: Image.network(
//                                   "https://avatar.iran.liara.run/public/boy"),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 10,
//                           right: -0,
//                           child: Container(
//                             width: 12,
//                             height: 12,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(100),
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Text(
//                       "Transfer",
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: ShaderMask(
//                         shaderCallback: (bounds) => const LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                           colors: [Colors.deepPurple, Colors.blue],
//                           tileMode: TileMode.mirror,
//                           transform: GradientRotation(3.14 / 4),
//                         ).createShader(bounds),
//                         child: const Icon(
//                           Icons.add,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                       ),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: List.generate(4, (idx) {
//                     return CardIcon(
//                       key: Key("card-icon-$idx"),
//                     );
//                   }),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 1,
//                       blurRadius: 7,
//                       offset: const Offset(1, 3),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   onChanged: (value) {
//                     context.read<UserBloc>().add(SearchUser(query: value));
//                   },
//                   cursorColor: Colors.deepPurple,
//                   decoration: InputDecoration(
//                     hintText: 'Search',
//                     prefixIcon: const Icon(Icons.search),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               BlocBuilder<UserBloc, UserState>(
//                 builder: (context, state) {
//                   if (state is UserLoading) {
//                     return Column(
//                       children: List.generate(
//                         5,
//                         (index) => const CardSkeleton(),
//                       ),
//                     );
//                   } else if (state is UserNoData) {
//                     return const Center(child: Text('No data found'));
//                   } else if (state is UserLoaded) {
//                     return Column(
//                       children: AnimateList(
//                         interval: 100.ms,
//                         effects: [
//                           SlideEffect(
//                             duration: 500.ms,
//                             curve: Curves.easeInOut,
//                             begin: const Offset(-1, 0),
//                             end: const Offset(0, 0),
//                           ),
//                           FadeEffect(
//                             duration: 500.ms,
//                             curve: Curves.easeInOut,
//                           ),
//                         ],
//                         children: state.users
//                             .map((user) => CardUser(
//                                   key: Key(user.id.toString()),
//                                   user: user,
//                                 ))
//                             .toList()
//                             .expand((element) =>
//                                 [element, const SizedBox(height: 20)])
//                             .toList(),
//                       ),
//                     );
//                   } else if (state is UserError) {
//                     return Center(child: Text('Error: ${state.message}'));
//                   }
//                   return const Center(child: Text('No users found'));
//                 },
//               ),
//               const SizedBox(height: 10),
//               const CarouselCard(),
//               const SizedBox(height: 10),
//               const Text("Hello").animate().fade(duration: 500.ms).slideX(
//                     delay: 500.ms,
//                   ),
//               const SizedBox(height: 80),
//               Column(
//                 children: List.generate(5, (index) {
//                   return AnimatedVisibilityWidget(
//                     key: Key('animated-$index'),
//                     beforeChild: const SizedBox(
//                       width: 100,
//                       height: 100,
//                     ),
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       color: Colors.red,
//                       child: Center(
//                         child: Text('Widget $index'),
//                       ),
//                     ).animate().fade(duration: 500.ms).scale(
//                           duration: 500.ms,
//                         ),
//                   );
//                 })
//                     .expand((element) => [element, const SizedBox(height: 20)])
//                     .toList(),
//               ),
//               // SizedBox(height: 100),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BlocProvider.value(
//                 value: BlocProvider.of<UserBloc>(context),
//                 child: UserFormScreen(),
//               ),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
