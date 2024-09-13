import 'package:bloctest/bloc/novelspecial/novelspecial_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class NovelSpecialPage extends StatefulWidget {
  const NovelSpecialPage({super.key});

  @override
  State<NovelSpecialPage> createState() => _NovelSpecialPageState();
}

class _NovelSpecialPageState extends State<NovelSpecialPage> {
  int currentIndex = 0;
  Timer? timer;
  VideoPlayerController videoPlayerController =
      VideoPlayerController.networkUrl(Uri.parse(''));
  bool isVideoInitialized = false;
  DateTime? lastRefreshTime;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _onFetch();
    _startImageSwitching();
  }

  Future<void> _onFetch() async {
    context.read<NovelspecialBloc>().add(FetchNovelSpecial());
  }

  Future<void> _onrefresh() async {
    final now = DateTime.now();
    if (lastRefreshTime == null ||
        now.difference(lastRefreshTime!) > const Duration(seconds: 10)) {
      lastRefreshTime = now;
      setState(() {
        isVideoInitialized = false;
        currentIndex = 0;
      });
      await novelBox.delete('specialData');
      context.read<NovelspecialBloc>().add(FetchNovelSpecial());
      _refreshController.refreshCompleted();
    } else {
      BookmarkManager(context, (bool checkAdd) {})
          .showToast('กรุณารอสักครู่ก่อนดำเนินการอีกครั้ง');
      _refreshController.refreshCompleted();
    }
  }

  void _startImageSwitching() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        currentIndex = ((currentIndex + 1) % 4).toInt();
      });
    });
  }

  @override
  void dispose() {
    print('dispose');
    timer?.cancel();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.grey[200],
          color: Colors.black,
          distance: 60,
        ),
        physics: const BouncingScrollPhysics(),
        onRefresh: () async {
          await _onrefresh();
        },
        child: BlocConsumer<NovelspecialBloc, NovelspecialState>(
          listener: (context, state) async {
            if (state is NovelspecialFailure) {
              // หากเกิดข้อผิดพลาด สามารถทำการแสดง SnackBar หรือแจ้งเตือนผู้ใช้ได้
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error occurred while fetching data!')),
              );
            } else if (state is NovelspecialSuccess) {
              if (!isVideoInitialized) {
                videoPlayerController = VideoPlayerController.networkUrl(
                  Uri.parse(state.specialPage.specialBanner![0].videoApp!),
                )..initialize().then((_) {
                    setState(() {
                      isVideoInitialized = true;
                      videoPlayerController.play();
                      videoPlayerController.setLooping(true);
                    });
                  });
              }
            }
          },
          builder: (context, state) {
            print(state);
            if (state is NovelspecialLoading) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.grey,
                  secondRingColor: Colors.black,
                  thirdRingColor: Colors.red[900]!,
                  size: 50,
                ),
              );
            } else if (state is NovelspecialSuccess) {
              print(state.specialPage.specialBanner![0].sb!.id);
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 0),
                  // width: double.infinity,
                  // height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          state.specialPage.specialBanner![0].bgImg!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topCenter,
                        height: 210,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              top: 4,
                              left: 7,
                              right: 0,
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.network(
                                  state.specialPage.specialBanner![0].fontImg!,
                                  color: Colors.black,
                                  fit: BoxFit.cover,
                                  height: 210,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 210,
                                child: CachedNetworkImage(
                                  imageUrl: state
                                      .specialPage.specialBanner![0].fontImg!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.black,
                                    child: Container(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          child: Container(
                            key: ValueKey<int>(currentIndex),
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  state.specialPage
                                      .specialCharacter![currentIndex].img!,
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/reading-book.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'อ่านเลย',
                                style: GoogleFonts.athiti(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/Eye_fill@3x.svg',
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    abbreviateNumber(state.specialPage
                                            .specialBanner![0].sb!.view ??
                                        0),
                                    style: GoogleFonts.athiti(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/iconmonstr-speech-bubble-27.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'ความคิดเห็น',
                                      style: GoogleFonts.athiti(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl:
                                state.specialPage.specialBanner![0].banner!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.black,
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.specialPage.specialCharacter!
                                .asMap()
                                .entries
                                .map(
                                  (entry) {
                                    final character = entry.value;
                                    return Container(
                                      width: 230,
                                      height: 750,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(200),
                                          topRight: Radius.circular(200),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 210,
                                            height: 210,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        character.img!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              character.des!,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.athiti(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              child: Text(
                                                character.name!,
                                                style: GoogleFonts.athiti(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  },
                                )
                                .toList()
                                .expand((element) => [
                                      element,
                                      const SizedBox(width: 20),
                                    ])
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Text(state.specialPage.specialBanner![0].video!),

                      Platform.isAndroid
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: HtmlWidget(
                                  onLoadingBuilder:
                                      (context, element, loadingProgress) {
                                    return Container(
                                      height: 800,
                                      width: 1200,
                                      child: Center(
                                        child: LoadingAnimationWidget
                                            .discreteCircle(
                                          color: Colors.grey,
                                          secondRingColor: Colors.black,
                                          thirdRingColor: Colors.red[900]!,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                                  """
<video class="banner-img" src="${state.specialPage.specialBanner![0].video!}"autoplay="" loop="" style="width: 1200px; height: 800px;"><source src="${state.specialPage.specialBanner![0].video!}" type="video/webm"></video>
""",
                                ),
                              ),
                            )
                          : isVideoInitialized
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AspectRatio(
                                      aspectRatio: videoPlayerController
                                          .value.aspectRatio,
                                      child: VideoPlayer(videoPlayerController),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl:
                                state.specialPage.specialBanner![0].footerImg!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            } else if (state is NovelspecialFailure) {
              return Center(
                child: Text('Error'),
              );
            } else if (state is NovelspecialEmpty) {
              return Center(
                child: Text('Empty'),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
