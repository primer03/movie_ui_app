import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/widgets/ExpansionTileEpisode.dart';
import 'package:flutter/material.dart';

class Epview extends StatelessWidget {
  const Epview({
    super.key,
    required this.groupList,
    required this.novelEp,
    required this.bookname,
    required this.role,
  });

  final List<String> groupList;
  final List<NovelEp> novelEp;
  final String bookname;
  final String role;

  @override
  Widget build(BuildContext context) {
    var novelEpx = novelEp.where((element) {
      return !element.name.contains('ประกาศ');
    }).toList();
    novelEpx.forEach((element) {
      if (element.name.contains('ประกาศ')) {
        print('ID: ${element.epId} Name: ${element.name}');
      }
    });
    print('จำนวนตอน: ${novelEpx.length}');

    final novelEpisode = _splitEpisodes(novelEpx, 100);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemCount: groupList.length,
        itemBuilder: (context, index) {
          final group = groupList[index];
          final episodes = novelEpisode[index];
          return Column(
            children: [
              ExpansionTileEpisode(
                key: ValueKey(group),
                novelEp: episodes,
                title: group,
                index: index,
                initiallyExpanded: index == 0,
                allEP: novelEp.length,
                bookname: bookname,
                novelEpAll: novelEp,
                role: role,
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  List<List<NovelEp>> _splitEpisodes(List<NovelEp> episodes, int chunkSize) {
    return [
      for (var i = 0; i < episodes.length; i += chunkSize)
        episodes.skip(i).take(chunkSize).toList()
    ];
  }
}
