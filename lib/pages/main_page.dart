import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloctest/bloc/noveldetail/novel_detail_bloc.dart';
import 'package:bloctest/bloc/user/user_bloc.dart';
import 'package:bloctest/function/app_function.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/pages/library/library_page.dart';
import 'package:bloctest/pages/special/novel_special_page.dart';
import 'package:bloctest/pages/user_page.dart';
import 'package:bloctest/service/BookmarkManager.dart';
import 'package:bloctest/service/SocketService.dart';
import 'package:bloctest/widgets/ContainerSkeltion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloctest/bloc/page/page_bloc.dart';
import 'package:bloctest/pages/home/novel_home.dart';
import 'package:bloctest/widgets/IconBottombar.dart';
import 'package:bloctest/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io' show Platform;

import 'package:toastification/toastification.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  bool closeloading = true;
  var now = DateTime.now();
  DateTime? lastPressed;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isConnect = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        disconnectSocket();
        if (isConnect) {
          isConnect = false;
        }

        // print('ไม่มีการเชื่อมต่ออินเทอร์เน็ต');
        // BookmarkManager(context, (bool checkAdd) {})
        //     .showToast('ไม่มีการเชื่อมต่ออินเทอร์เน็ต');
      } else if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        if (!isConnect) {
          setupSocket();
          isConnect = true;
        }
        // print('กำลังเชื่อมต่ออินเทอร์เน็ต');

        // BookmarkManager(context, (bool checkAdd) {})
        //     .showToast('เชื่อมต่ออินเทอร์เน็ตแล้ว');
        // getUser();
      }
    });
    getUser();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void getUser() async {
    final userstr = await novelBox.get('user');
    final isSocial = await novelBox.get('loginsocial');
    print('isSocial: $isSocial');
    Logger().i('userstr: $userstr');
    final logintype = await novelBox.get('loginType');
    if (userstr == null) {
      await ondispose();
      Navigator.pushNamed(context, '/login');
      return;
    }
    final user = User.fromJson(jsonDecode(userstr));
    final password = logintype == 'remember' ? await getPassword() : null;
    // ignore: use_build_context_synchronously
    // print('img: ${user.img}');
    // BlocProvider.of<UserBloc>(context)
    //     .add(UserLoginremember(user: user, password: password));
    context.read<UserBloc>().add(UserLoginremember(
        user: user,
        password: password,
        type: isSocial != null ? 'social' : 'nomal'));
  }

  @override
  void dispose() {
    subscription.cancel();
    Logger().i('subscription cancel');
    super.dispose();
  }

  Future<void> ondispose() async {
    await novelBox.clear();
    await deletePassword();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        const maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          lastPressed = DateTime.now();
          BookmarkManager(context, (bool checkAdd) {})
              .showToast('กดอีกครั้งเพื่อออกจากหน้านี้');
          return;
        }
        //ปิดแอพ
        SystemNavigator.pop();
      },
      child: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          return BlocListener<NovelDetailBloc, NovelDetailState>(
            listener: (BuildContext context, NovelDetailState state) {},
            child: Scaffold(
              backgroundColor: Colors.white,
              body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      surfaceTintColor: Colors.white,
                      backgroundColor: Colors.white,
                      leading: BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) async {
                          if (state is UserLoginrememberSate) {
                            print('state.user.img: ${state.user.img}');
                            print(
                                'state.user.img: ${state.user.img.split('/').last}');
                            final isSocial = await novelBox.get('loginsocial');
                            if (isSocial != null) {
                              if (state.user.img.split('/').last ==
                                  'default_profile.jpg') {
                                final password = await getPassword();
                                context.read<UserBloc>().add(UserLoginremember(
                                    user: state.user,
                                    password: password,
                                    type: ''));
                              }
                            }

                            setState(() {
                              now = DateTime.now()
                                  .add(const Duration(seconds: 3));
                              print(
                                  '${state.user.img}?time=${now.millisecondsSinceEpoch}');
                            });
                          } else if (state is UserLoadedProfileFailed) {
                            print('state: ${state.message}');
                          } else if (state is UserLoginRemeberFailed) {
                            Logger().i('state: ${state.message}');
                            await logoutAll(context);
                          }
                        },
                        builder: (context, state) {
                          if (state is UserLoginrememberSate) {
                            return Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[300],
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${state.user.img}?time=${now.millisecondsSinceEpoch}',
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Iconsax.user),
                                ),
                              ),
                            );
                          } else if (state is UserLoading) {
                            return IconButton(
                              onPressed: () {},
                              icon: const Icon(Iconsax.user),
                            );
                          }
                          return Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                            ),
                          );
                        },
                      ),

                      title: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoginrememberSate) {
                            if (closeloading) {
                              closeloading = false;
                              // Navigator.pop(context);
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.username,
                                  style: GoogleFonts.kanit(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'มาหานิยายที่คุณชื่นชอบกันเถอะ',
                                  style: GoogleFonts.kanit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[100]!,
                            period: const Duration(milliseconds: 1000),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ContainerSkeltion(
                                  height: 12,
                                  width: 90,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                const SizedBox(height: 5),
                                ContainerSkeltion(
                                  height: 10,
                                  width: 170,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/search');
                          },
                          icon: const Icon(Iconsax.search_normal_1),
                        ),
                        IconButton(
                          onPressed: () async {
                            // Logger().i(novelBox.keys.f);
                            for (var element in novelBox.keys) {
                              print(element);
                            }
                          },
                          icon: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // disconnectSocket();
                                },
                                child: const Icon(Iconsax.notification_bing),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      elevation: 10.0,
                      automaticallyImplyLeading: false,
                      // expandedHeight: 50,
                      floating: true,
                      snap: true,
                    )
                  ];
                },
                body: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: _getPage(state.tabIndex, context),
                ),
              ),
              bottomNavigationBar: Container(
                padding: Platform.isIOS
                    ? const EdgeInsets.only(
                        bottom: 15,
                      )
                    : const EdgeInsets.only(
                        bottom: 0,
                      ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Platform.isIOS
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      topRight: Platform.isIOS
                          ? const Radius.circular(0)
                          : const Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconBottombar(
                        state: state,
                        tabIndex: 0,
                        icon: 'assets/svg/home-line.svg',
                      ),
                      IconBottombar(
                        state: state,
                        tabIndex: 1,
                        size: 27,
                        icon: 'assets/svg/Star_duotone.svg',
                      ),
                      IconBottombar(
                        state: state,
                        tabIndex: 2,
                        icon: 'assets/svg/library-book-svgrepo-com.svg',
                      ),
                      IconBottombar(
                        state: state,
                        tabIndex: 3,
                        icon: 'assets/svg/Setting_line_duotone_line@3x.svg',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const MovieHome();
      case 1:
        return const NovelSpecialPage();
      case 2:
        return const LibraryPage();
      case 3:
        return const UserPage();
      default:
        return const SizedBox.shrink();
    }
  }
}
