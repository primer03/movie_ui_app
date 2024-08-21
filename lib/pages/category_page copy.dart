import 'package:bloctest/bloc/novelcate/novel_cate_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.cateId});
  final int cateId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  final List<String> data = List.generate(10, (index) => 'Category $index');

  // TabController More Information => https://api.flutter.dev/flutter/material/TabController-class.html
  late TabController tabController;

  // Instantiate scroll_to_index (套件提供的方法)
  late AutoScrollController autoScrollController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: data.length, vsync: this);
    autoScrollController = AutoScrollController();
    context.read<NovelCateBloc>().add(FetchNovelCate(cateID: widget.cateId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NovelCateBloc, NovelCateState>(
          builder: (context, NovelCateState state) {
        if (state is NovelCateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NovelCateLoaded) {
          return VerticalScrollableTabView(
            autoScrollController: autoScrollController,
            scrollbarThumbVisibility: false,
            tabController: tabController,
            listItemData: data,
            verticalScrollPosition: VerticalScrollPosition.begin,
            eachItemChild: (object, index) => Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  child: Center(
                    child: Text(
                      object.toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            slivers: [
              SliverAppBar(
                pinned: true,
                // expandedHeight: 250.0,
                centerTitle: true,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                title: const Text("SliverAppBar"),
                // flexibleSpace: const FlexibleSpaceBar(
                //   centerTitle: true,
                //   title: Text("SliverAppBar"),
                //   titlePadding: EdgeInsets.only(bottom: 50),
                //   collapseMode: CollapseMode.pin,
                //   background: FlutterLogo(),
                // ),
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  controller: tabController,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                  indicatorColor: Colors.cyan,
                  labelColor: Colors.cyan,
                  unselectedLabelColor: Colors.blue,
                  indicatorWeight: 3.0,
                  tabs: data.map((e) {
                    return Tab(
                      text: e,
                    );
                  }).toList(),
                  onTap: (index) {
                    VerticalScrollableTabBarStatus.setIndex(index);
                  },
                ),
              ),
            ],
          );
        } else if (state is NovelCateEmpty) {
          return const Center(child: Text('No data'));
        } else if (state is NovelCateError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
