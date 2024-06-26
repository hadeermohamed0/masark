import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:testm/dis.dart';
import 'package:http/http.dart' as http;


TileLayer get openStreetLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );

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

class normal extends StatefulWidget {
  static const String screenRoute = 'normal_screen';

  normal({Key? key}) : super(key: key);

  @override
  State<normal> createState() => _normalState();
}

class _normalState extends State<normal> {
  final TextEditingController searchController = TextEditingController();
  MapController mapController = MapController();
  final LatLng first=LatLng(31.034673246608666, 31.350752243978864);
  final LatLng sec=LatLng(31.04031523059393, 31.347308716649763);
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(31.04031523059393, 31.347308716649763)];


  @override
  void initState() {
    super.initState();
    drowPolyLine();
  }

  drowPolyLine()async{

    var url = Uri.parse('http://router.project-osrm.org/route/v1/driving/${first.longitude},${first.latitude};${sec.longitude},${sec.latitude}?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    print(response.body);
    setState(() {
      routpoints = [];
      var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for(int i=0; i< ruter.length; i++){
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[","");
        reep = reep.replaceAll("]","");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        routpoints.add(LatLng( double.parse(lat1[1]), double.parse(long1[0])));
      }
      isVisible = !isVisible;
      print(routpoints);
    });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
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
                      child: Icon(
                        Icons.mic_none_rounded,
                        size: 30,
                      ),
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
            // MyImage(imagePath: 'images/metro.png', fit: BoxFit.cover),
            Visibility(
              visible: isVisible,

              child: FlutterMap(
                options: MapOptions(
                    initialCenter: LatLng(31.04031523059393, 31.347308716649763),
                    initialZoom: 11,
                    interactionOptions: InteractionOptions(
                        flags: ~InteractiveFlag.doubleTapZoom)),
                children: [
                  openStreetLayer,
                  MarkerLayer(
                    markers: [

                      Marker(

                          point: first,

                          width: 150,
                          height: 150,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                  // width: 150,
                                  // alignment: Alignment.center,
                                  color: Colors.red,
                                  child: Text(
                                    'masarka',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                              Icon(
                                Icons.location_on_rounded,
                                size: 60,
                                color: Colors.red,
                              ),
                            ],
                          )),
                      Marker(
                          point: sec,
                          width: 150,
                          height: 150,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                  // width: 150,
                                  // alignment: Alignment.center,
                                  color: Colors.blue,
                                  child: Text(
                                    'my location',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                              InkWell(

                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 60,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          )),

                    ],
                  ),
                  PolylineLayer(
                    polylines: [

                      Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
