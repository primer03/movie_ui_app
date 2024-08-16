// import 'package:bloctest/bloc/user/user_bloc.dart';
// import 'package:bloctest/models/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class UserFormScreen extends StatefulWidget {
//   final User? user;

//   UserFormScreen({this.user});

//   @override
//   _UserFormScreenState createState() => _UserFormScreenState();
// }

// class _UserFormScreenState extends State<UserFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.user?.name ?? '');
//     _emailController = TextEditingController(text: widget.user?.email ?? '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.user == null ? 'Add User' : 'Edit User'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final userBloc = context.read<UserBloc>();
//                     if (widget.user == null) {
//                       userBloc.add(AddUser(
//                         name: _nameController.text,
//                         email: _emailController.text,
//                       ));
//                     } else {
//                       final updatedUser = User(
//                         id: widget.user!.id,
//                         name: _nameController.text,
//                         email: _emailController.text,
//                       );
//                       userBloc.add(UpdateUser(user: updatedUser));
//                     }
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Text(widget.user == null ? 'Add' : 'Update'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
// }
