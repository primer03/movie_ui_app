import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ค้นหายอดฮิต',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.black, // Use single color directly
                    onPrimary: Colors.white,
                    secondary: Colors.blue,
                    onSecondary: Colors.white,
                    surface: Colors.grey[200]!,
                    onSurface: Colors.black,
                    error: Colors.red,
                    onError: Colors.white,
                  ),
                  textSelectionTheme:
                      const TextSelectionThemeData(cursorColor: Colors.blue),
                ),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: 'ค้นหา',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: SvgPicture.asset('assets/svg/Filter@3x.svg'),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ค้นหาล่าสุด',
                    style: GoogleFonts.athiti(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'ดูทั้งหมด',
                      style: GoogleFonts.athiti(
                        color: Colors.red[900],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                children: [
                  ...List.generate(5, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 5, bottom: 5),
                      child: Chip(
                        deleteButtonTooltipMessage: 'ลบ',
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        label: Text(
                          'นิยาย $index',
                          style: GoogleFonts.athiti(
                            color: const Color(0xFF96979B),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        onDeleted: () {
                          print('Delete');
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        deleteIcon: SvgPicture.asset(
                          'assets/svg/close_ring_duotone_line@3x.svg',
                          width: 25,
                          height: 25,
                          color: const Color(0xff96979B),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF9D9D9D9),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'การค้นหายอดฮิต',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 0.1,
                                  offset: const Offset(4, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/20240708021924.png',
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'หวนกลับมาเป็นคนโปรดของฮ่องเต้',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ความแค้นในใจนั้นยากจะลบเลือน... หากมีโอกาสอีกคราผู้ใดเล่าจะไม่คิดหวนคืนมา ความชิงชังที่สุมอยู่เต็มทรวงของ \'อันหรูอี้\' นั้นมิเคยเสื่อมคลาย โอกาสที่ฟ้าประทานมานางย่อมคว้าไว้ไม่ให้หลุดมือ ทว่าท่ามกลางไฟแค้นที่ลุกโชนกลับมีตัวแปรอื่นที่ทำให้นางผันเปลี่ยนไป',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '1.2k',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '1,250',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.thumb_up,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '100',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
