
import 'package:flutter/material.dart';
import 'package:testm/dis.dart';

class normal extends StatelessWidget {
  normal({Key? key}) : super(key: key);

  static const String screenRoute = 'normal_screen';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 3,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 350,
              height: 45,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      right: 5,

                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => dis()),
                        );
                      },
                      child: Icon(Icons.mic_none_rounded,
                      size: 30,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Stack(
          children: [
            MyImage(imagePath: 'images/metro.png', fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;

  const MyImage({required this.imagePath, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        imagePath,
        fit: fit,
      ),
    );
  }
}
