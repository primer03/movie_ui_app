import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TestComment extends StatefulWidget {
  const TestComment({super.key});

  @override
  State<TestComment> createState() => _TestCommentState();
}

class _TestCommentState extends State<TestComment> {
  List<Map<String, String>> comments = [
    {
      'avatar':
          'https://i.pinimg.com/736x/dc/8f/54/dc8f54d6f625f1311894e240cefab79f.jpg',
      'userName': 'John Doe',
      'content': 'This is a great post!',
    },
    {
      'avatar':
          'https://i.pinimg.com/736x/dc/8f/54/dc8f54d6f625f1311894e240cefab79f.jpg',
      'userName': 'Jane Smith',
      'content': 'I totally agree with you.',
    },
  ];

  bool isShowEmojiPicker = false;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Test Comment'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 20),
            _buildShowCommentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'บัญชีของฉัน',
      style: GoogleFonts.athiti(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildShowCommentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showCommentModal(context);
      },
      child: const Text('Show Comment'),
    );
  }

  void _showCommentModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Material(
            color: Colors.white,
            child: Stack(
              children: [
                _buildCommentList(),
                _buildCommentInputArea(setStateModal),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentList() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          comments.length,
          (index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(comments[index]['avatar']!),
            ),
            title: Text(comments[index]['userName']!),
            subtitle: Text(comments[index]['content']!),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInputArea(Function(void Function()) setStateModal) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: _inputAreaDecoration(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      minLines: 1,
                      controller: commentController,
                      focusNode: commentFocusNode,
                      keyboardType: TextInputType.multiline,
                      style: GoogleFonts.athiti(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      cursorColor: Colors.black,
                      decoration: _inputDecoration(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.black, size: 24),
                    onPressed: () {
                      setStateModal(() {
                        isShowEmojiPicker = !isShowEmojiPicker;
                        if (isShowEmojiPicker) {
                          commentFocusNode.unfocus();
                        } else {
                          commentFocusNode.requestFocus();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/Send_fill@3x.svg',
                      color: Colors.black,
                      width: 30,
                    ),
                    onPressed: () {
                      // Add send action here
                    },
                  ),
                ],
              ),
              if (isShowEmojiPicker) const SizedBox(height: 10),
              if (isShowEmojiPicker) _buildEmojiPicker(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _inputAreaDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[300],
      hintText: 'เพิ่มความคิดเห็น...',
      hintStyle: GoogleFonts.athiti(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black.withOpacity(0.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return Container(
      height: 200,
      color: Colors.white,
      child: AlignedGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.grey,
              onTap: () {
                // Add emoji picker action here
              },
              child: Image.network(
                'https://serverimges.bookfet.com/mascot/1.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
