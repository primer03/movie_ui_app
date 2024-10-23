import 'dart:math';

import 'package:bloctest/bloc/allcomment/allcomment_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

enum LineStyle {
  dashed,
  dotted,
  solid,
}

class CommentAllPage extends StatefulWidget {
  final String bookID;
  final List<NovelEp> novelEp;
  const CommentAllPage(
      {super.key, required this.bookID, required this.novelEp});

  @override
  State<CommentAllPage> createState() => _CommentAllPageState();
}

class _CommentAllPageState extends State<CommentAllPage> {
  List<Map<String, dynamic>> _selectedComment = [];
  String novelName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AllcommentBloc>().add(AllcommentFetch(bookID: widget.bookID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     novelName,
      //     style: GoogleFonts.athiti(
      //       fontSize: 15,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   surfaceTintColor: Colors.white,
      // ),
      backgroundColor: Colors.white,

      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // expandedHeight: 200,
              floating: true,
              // pinned: true,
              snap: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              foregroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  novelName,
                  style: GoogleFonts.athiti(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ];
        },
        body: BlocConsumer<AllcommentBloc, AllcommentState>(
            listener: (context, state) {
          if (state is AllcommentError) {
          } else if (state is AllcommentLoaded) {
            Logger().i(
                'จำนวนคอมเม้นท์ ${state.comments.comment![0].uscmImgProfile}');
            // Logger().i(
            //     'จำนวนคอมเม้นท์ย่อย ${state.comments.comment![13].subcomment?[0]['btcs.comment']}');
            for (int i = 0; i < state.comments.comment!.length; i++) {
              _selectedComment.add({'id': i, 'showReply': false});
            }
            setState(() {
              _selectedComment = _selectedComment;
              novelName = state.comments.novelData!.btName ?? '';
            });
          }
        }, builder: (context, state) {
          if (state is AllcommentLoading) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.red[900]!,
                rightDotColor: Colors.black,
                size: 100,
              ),
            );
          }
          if (state is AllcommentLoaded) {
            return Container(
              // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: double.infinity,
              child: Scrollbar(
                // interactive: true,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: _selectedComment.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      key: ValueKey(state.comments.comment![index].cmId),
                      margin:
                          EdgeInsets.only(bottom: 20, top: index == 0 ? 20 : 0),
                      child: CommentTreeWidget<CommentWithDateTime,
                          CommentWithDateTime>(
                        CommentWithDateTime(
                            dateAt: null,
                            avatar: 'null',
                            userName: 'null',
                            content:
                                'felangel made felangel/cubit_and_beyond public '),
                        _selectedComment[index]['showReply']
                            ? [
                                ...state.comments.comment![index].subcomment!
                                    .map((e) {
                                  print('Comment: ${e}');
                                  return CommentWithDateTime(
                                    avatar: e['btcs.img_profile'] ??
                                        'https://serverimges.bookfet.com/profile_img/default_profile.jpg',
                                    userName: e['btcs.userName'] ?? '',
                                    content: e['btcs.comment'] ?? 'ไม่มีข้อมูล',
                                    dateAt: e['btcs.date_at'] != null
                                        ? DateTime.parse(e['btcs.date_at'])
                                        : null,
                                  );
                                }),
                              ]
                            : [],
                        treeThemeData: TreeThemeData(
                            lineColor: _selectedComment[index]['showReply']
                                ? Colors.grey[300]!
                                : Colors.white,
                            lineWidth: 2),
                        avatarRoot: (context, data) => PreferredSize(
                          preferredSize: Size.fromRadius(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://serverimges.bookfet.com/profile_img/${state.comments.comment![index].uscmImgProfile}',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                                placeholder: (context, url) => Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        avatarChild: (context, data) => PreferredSize(
                          preferredSize: Size.fromRadius(12),
                          child: Container(
                            width: 36,
                            height: 36,
                            // color: Colors.grey,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                width: 36,
                                height: 36,
                                imageUrl: data.avatar != null
                                    ? 'https://serverimges.bookfet.com/profile_img/${data.avatar}'
                                    : 'https://serverimges.bookfet.com/profile_img/default_profile.jpg',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                                placeholder: (context, url) => Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        contentChild: (context, data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.userName ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      data.dateAt != null
                                          ? formatThaiDate(data.dateAt!)
                                          : '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    // const SizedBox(height: 4),
                                    Html(
                                      data: data.content,
                                      style: {
                                        'p': Style(
                                          fontFamily:
                                              GoogleFonts.athiti().fontFamily,
                                          fontSize: FontSize(17),
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                        ),
                                        'img': Style(
                                          width: Width(300),
                                          height: Height(300),
                                        ),
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        contentRoot: (context, data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.comments.comment![index].userName ??
                                          '',
                                      style: GoogleFonts.athiti(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      state.comments.comment![index].dateAt !=
                                              null
                                          ? formatThaiDate(state
                                              .comments.comment![index].dateAt!)
                                          : '',
                                      style: GoogleFonts.athiti(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    // const SizedBox(height: 4),
                                    Html(
                                      data: state
                                          .comments.comment![index].comment!,
                                      style: {
                                        'p': Style(
                                          fontFamily:
                                              GoogleFonts.athiti().fontFamily,
                                          fontSize: FontSize(17),
                                          fontWeight: FontWeight.w600,
                                          textAlign: TextAlign.start,
                                        ),
                                        'img': Style(
                                          width: Width(300),
                                          height: Height(300),
                                        ),
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          'reader',
                                          arguments: {
                                            'bookId': state.comments
                                                .comment![index].bookId,
                                            'epId': state
                                                .comments.comment![index].epId,
                                            'bookName': novelName,
                                            'novelEp': widget.novelEp,
                                          },
                                        );
                                      },
                                      child: Text(
                                        state.comments.comment![index]
                                                    .btepName !=
                                                null
                                            ? '[ จากตอน "${state.comments.comment![index].btepName}" ]'
                                            : '',
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.athiti(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DefaultTextStyle(
                                style: GoogleFonts.athiti(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 16,
                                            color: Colors.grey[700],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            state.comments.comment![index].likes
                                                .toString(),
                                            style: GoogleFonts.athiti(
                                              fontSize: 15,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 24),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedComment[index]
                                                    ['showReply'] =
                                                !_selectedComment[index]
                                                    ['showReply'];
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'ตอบกลับ',
                                              style: GoogleFonts.athiti(
                                                fontSize: 15,
                                                color: state
                                                        .comments
                                                        .comment![index]
                                                        .subcomment!
                                                        .isNotEmpty
                                                    ? Colors.black
                                                    : Colors.grey[700],
                                                fontWeight: state
                                                        .comments
                                                        .comment![index]
                                                        .subcomment!
                                                        .isNotEmpty
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              state.comments.comment![index]
                                                          .subcomment !=
                                                      null
                                                  ? state
                                                      .comments
                                                      .comment![index]
                                                      .subcomment!
                                                      .length
                                                      .toString()
                                                  : '0',
                                              style: GoogleFonts.athiti(
                                                fontSize: 15,
                                                color: state
                                                        .comments
                                                        .comment![index]
                                                        .subcomment!
                                                        .isNotEmpty
                                                    ? Colors.black
                                                    : Colors.grey[700],
                                                fontWeight: state
                                                        .comments
                                                        .comment![index]
                                                        .subcomment!
                                                        .isNotEmpty
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is AllcommentError) {
            return Center(
              child: Text(
                'ยังไม่มีคอมเม้นท์',
                style: GoogleFonts.athiti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }
}

class CommentWithDateTime extends Comment {
  DateTime? dateAt;

  CommentWithDateTime({
    required super.avatar,
    required super.userName,
    required super.content,
    required this.dateAt,
  });
}
