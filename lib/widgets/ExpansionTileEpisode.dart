import 'package:bloctest/models/novel_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpansionTileEpisode extends StatefulWidget {
  final bool initiallyExpanded;
  final int index;
  final String title;
  final List<NovelEp> novelEp;
  final List<NovelEp> novelEpAll;
  final int allEP;
  final String bookname;
  final String role;

  const ExpansionTileEpisode({
    super.key,
    this.initiallyExpanded = false,
    required this.index,
    required this.title,
    required this.novelEp,
    required this.novelEpAll,
    required this.allEP,
    required this.bookname,
    required this.role,
  });

  @override
  _ExpansionTileEpisodeState createState() => _ExpansionTileEpisodeState();
}

class _ExpansionTileEpisodeState extends State<ExpansionTileEpisode> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  String formatDate(String originalDate) {
    DateTime dateTime = DateTime.parse(originalDate);
    DateFormat dateFormat = DateFormat('d MMM yyyy', 'th_TH');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        splashFactory: InkRipple.splashFactory,
        splashColor: Colors.black.withOpacity(0.4),
      ),
      child: ExpansionTile(
        key: PageStorageKey<String>('expansion_tile_key${widget.index}'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(
          widget.title,
          style: GoogleFonts.athiti(
            fontWeight: FontWeight.w700,
          ),
        ),
        collapsedIconColor: Colors.black,
        iconColor: Colors.white,
        textColor: Colors.white,
        collapsedBackgroundColor: Colors.grey[200],
        backgroundColor: Colors.black,
        collapsedTextColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: Colors.grey[200]!,
                ),
                right: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              key: PageStorageKey<String>('listview_key${widget.index}'),
              itemCount: widget.novelEp.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final episode = widget.novelEp[index];
                return ListTile(
                  splashColor: Colors.grey,
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'reader',
                      arguments: {
                        'bookId': episode.bookId,
                        'epId': episode.epId,
                        'bookName': widget.bookname,
                        'novelEp': widget.novelEpAll,
                      },
                    );
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          episode.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.athiti(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    formatDate(episode.publishDate.toString()),
                    style: GoogleFonts.athiti(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: episode.typeRead.name == 'FREE'
                      ? Text(
                          'อ่านฟรี',
                          style: GoogleFonts.athiti(
                              fontSize: 14, color: Colors.grey),
                        )
                      : (widget.role == 'public')
                          ? Text(
                              'อ่าน',
                              style: GoogleFonts.athiti(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.yellow[700],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'VIP',
                                style: GoogleFonts.athiti(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                );
                // child: Container(
                //   padding: const EdgeInsets.all(15),
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         color: Colors.grey[200]!,
                //       ),
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Text(
                //           episode.name,
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //           style: GoogleFonts.athiti(
                //             fontSize: 17,
                //             fontWeight: FontWeight.w700,
                //           ),
                //         ),
                //       ),
                //       episode.typeRead.name == 'FREE'
                //           ? Text(
                //               'อ่านฟรี',
                //               style: GoogleFonts.athiti(
                //                 color: Colors.grey[400],
                //                 fontWeight: FontWeight.w600,
                //                 fontStyle: FontStyle.italic,
                //               ),
                //             )
                //           : widget.role == 'public'
                //               ? Text(
                //                   'อ่าน',
                //                   style: GoogleFonts.athiti(
                //                     color: Colors.grey[400],
                //                     fontWeight: FontWeight.w600,
                //                     fontStyle: FontStyle.italic,
                //                   ),
                //                 )
                //               : SvgPicture.asset(
                //                   'assets/svg/crown-user-svgrepo-com.svg',
                //                   width: 20,
                //                 )
                //     ],
                //   ),
                // ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
