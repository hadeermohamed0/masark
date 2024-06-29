import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dis.dart';

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
  final LatLng? destination;
  normal({Key? key, this.destination}) : super(key: key);

  @override
  State<normal> createState() => _normalState();
}

TileLayer get openStreetLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );

class _normalState extends State<normal> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  MapController mapController = MapController();
  double zoom = 11;
  LatLng center = LatLng(31.04031523059393, 31.347308716649763);
  LatLng myLocatonfirst = LatLng(31.034673246608666, 31.350752243978864);
  late LatLng destination ;
  LatLng from = LatLng(31.23266031597589, 30.235546657192405);
  LatLng to = LatLng(31.232669128863687, 30.030751240155272);

  bool isVisible = false;
  List<LatLng> routpoints = [];
  bool isFirist = true;
  MyLocationProvider myLocationProvider = MyLocationProvider();

  drowPolyLine({
    LatLng? x1,
    LatLng? x2,
  }) async {
    routpoints = [];
    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${x1?.longitude ?? myLocatonfirst.longitude},${x1?.latitude ?? myLocatonfirst.latitude};${x2?.longitude ?? destination.longitude},${x2?.latitude ?? destination.latitude}?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    log(response.body);
    setState(() {
      var ruter =
          jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < ruter.length; i++) {
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");

        routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      if (isFirist) {
        isVisible = !isVisible;
      }
      // LatLng(latitude:30.037033, longitude:31.238362)
      isFirist = false;
      log(routpoints.toString());
    });
  }

  void searchPlace(String placeName, bool isDraw) async {
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        setState(() {
          center = LatLng(locations.first.latitude, locations.first.longitude);
          zoom = 16.0;
          mapController.move(center, zoom);
          LatLng x =
              LatLng(locations.first.latitude, locations.first.longitude);
          isDraw
              ? isMulti
                  ? to = x
                  : destination = x
              : from = x;
          if (isDraw) {
            drowPolyLine(
              x1: !isMulti ? myLocatonfirst : from,
              x2: !isMulti ? destination : to,
            );
          }
        });

        // Move map to the searched location
      } else {
        // Handle case where no location found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Not Found'),
            content: Text('No results found for your query.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error searching for place: $e');
      // Handle error or display a message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred while searching for the place.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    destination=widget.destination??LatLng(31.04031523059393, 31.347308716649763);
    // myLocationProvider.getLocation();
    myLocationProvider.requestPermission();
    trackUserLocation();
    super.initState();
  }

  bool isMulti = false;

  trackUserLocation() async {
    await myLocationProvider.trackUserLocation().listen((newLocation) {
      log("frommmmmmmmmmmmmmmmmmmmmmmmm");
      log("newLocation.latitude");
      log("${newLocation.latitude}");
      log("newLocation?.longitude");
      log("${newLocation.longitude}");
      log("newLocation.accuracy");
      log("${newLocation.accuracy}");
      log("newLocation?.speed");
      log("${newLocation.speed}");
      log("newLocation?.speed Accuracy");
      log("${newLocation.speedAccuracy}");
      log("newLocation?.time");
      log("${newLocation.time}");
      log('hhhhhhhhhhhhhhhhhhhhh');
      log(myLocatonfirst.toString());
      myLocatonfirst =
          LatLng(newLocation.latitude ?? 0.0, newLocation.longitude ?? 0.0);
      drowPolyLine();
      setState(() {});
      log('hhhhhhhhhhhhhhhhhhhhh');
      log(myLocatonfirst.toString());

      // if (isVisible) {
      //   mapController.move(
      //       (LatLng(newLocation.latitude ?? 0.0, newLocation.longitude ?? 0.0)),
      //       16);
      // }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: isMulti ? 'from' : 'search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!.withOpacity(1),
                                )),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                searchPlace(searchController.text,
                                    isMulti ? false : true);
                              },
                            ),
                          ),
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
              if (isMulti)
                SizedBox(
                  height: 10,
                ),
              if (isMulti)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: searchController2,
                            decoration: InputDecoration(
                              hintText: 'To',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!.withOpacity(1),
                                  )),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  searchPlace(searchController2.text, true);
                                },
                              ),
                            ),
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
              Expanded(
                child: Visibility(
                  visible: isVisible,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                            // onTap: (x,y){
                            //   log(y.toString());
                            // },
                            initialCenter: center,
                            maxZoom: 18,
                            initialZoom: zoom,
                            interactionOptions: InteractionOptions(
                                flags: ~InteractiveFlag.doubleTapZoom)),
                        children: [
                          openStreetLayer,
                          MarkerLayer(
                            markers: [
                              Marker(
                                  point: myLocatonfirst,
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_back_ios_rounded,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('First Line'),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '7:45pm',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 20),
                                                  ),
                                                  Spacer(),
                                                  Text('7:05pm',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 20)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                              Slider(
                                                value: 50,
                                                onChanged: (v) {},
                                                activeColor: Colors.blue,
                                                min: 0,
                                                max: 100,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(''),
                                                  Spacer(),
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  Text('موقعك'),
                                                ],
                                              ),
                                              Text(
                                                'Total:50 EGP',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 250,
                                                        child: AlertDialog(
                                                          content: SizedBox(
                                                              height: 250,
                                                              width: double
                                                                  .infinity,
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(2),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            110,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // Icon(
                                                                            //   Icons
                                                                            //       .location_on,
                                                                            // ),
                                                                            Text(
                                                                              '5km',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Distance',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(2),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            110,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // Icon(
                                                                            //   Icons
                                                                            //       .watch_later,
                                                                            // ),
                                                                            Text(
                                                                              '1 Hour',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Time',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    height: 50,
                                                                    width: 130,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.grey)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .price_check_outlined,
                                                                        ),
                                                                        Text(
                                                                          '25 \$',
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          'Prise',
                                                                          style: TextStyle(
                                                                              color: Colors.blue,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          60,
                                                                      width:
                                                                          150,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .blue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(15)),
                                                                      child:
                                                                          Text(
                                                                        'Confirm',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Text(
                                                    'Next',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 60,
                                      color: Colors.blue,
                                    ),
                                  )),
                              Marker(
                                  point: destination,
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      log('kkkkkkkkkkkkkkkkkkkk');
                                      log(destination.toString());
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_back_ios_rounded,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('First Line'),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '7:45pm',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 20),
                                                  ),
                                                  Spacer(),
                                                  Text('7:05pm',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 20)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                              Slider(
                                                value: 50,
                                                onChanged: (v) {},
                                                activeColor: Colors.blue,
                                                min: 0,
                                                max: 100,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(''),
                                                  Spacer(),
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: Colors.blue,
                                                  ),
                                                  Text('موقعك'),
                                                ],
                                              ),
                                              Text(
                                                'Total:50 EGP',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 40,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SizedBox(
                                                        height: 250,
                                                        child: AlertDialog(
                                                          content: SizedBox(
                                                              height: 250,
                                                              width: double
                                                                  .infinity,
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                        EdgeInsets.all(2),
                                                                        height:
                                                                        50,
                                                                        width:
                                                                        110,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // Icon(
                                                                            //   Icons
                                                                            //       .location_on,
                                                                            // ),
                                                                            Text(
                                                                              '5km',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Distance',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                        EdgeInsets.all(2),
                                                                        height:
                                                                        50,
                                                                        width:
                                                                        110,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            // Icon(
                                                                            //   Icons
                                                                            //       .watch_later,
                                                                            // ),
                                                                            Text(
                                                                              '1 Hour',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Time',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                    height: 50,
                                                                    width: 130,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                        border: Border.all(
                                                                            color:
                                                                            Colors.grey)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .price_check_outlined,
                                                                        ),
                                                                        Text(
                                                                          '25 \$',
                                                                          style:
                                                                          TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Text(
                                                                          'Prise',
                                                                          style: TextStyle(
                                                                              color: Colors.blue,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                    Container(
                                                                      height:
                                                                      60,
                                                                      width:
                                                                      150,
                                                                      alignment:
                                                                      Alignment
                                                                          .center,
                                                                      padding:
                                                                      EdgeInsets.all(
                                                                          15),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .blue,
                                                                          borderRadius:
                                                                          BorderRadius.circular(15)),
                                                                      child:
                                                                      Text(
                                                                        'Confirm',
                                                                        style: TextStyle(
                                                                            color:
                                                                            Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: 60,
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                                  child: Text(
                                                    'Next',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },

                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 60,
                                      color: Colors.red,
                                    ),
                                  )),
                              Marker(
                                  point: LatLng(
                                      31.235461499170974, 30.029223370719002),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('السيدة زينب'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              150,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Text(
                                                                            'Confirm',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: LatLng(
                                      31.23822117050530, 30.036543395333496),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('سعد زغلول'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              150,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Text(
                                                                            'Confirm',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )),
                              //
                              Marker(
                                  point: LatLng(
                                      31.233902457803996, 30.034932994411193),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('شارع فاطمة يوسف'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              150,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Text(
                                                                            'Confirm',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: LatLng(
                                      31.233162415669277, 30.032489289179807),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('شارع اسماعيل سرى'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              150,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Text(
                                                                            'Confirm',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: LatLng(
                                      31.236826449571545, 30.032124403259715),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('شارع محمد شوقى'),
                                      InkWell(
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: LatLng(
                                      31.234745891562866, 30.236884704991596),
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text('شارع الجوالى'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(2),
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                110,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              150,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                              Text(
                                                                            'Confirm',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: from,
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text(searchController.text.isNotEmpty?searchController.text:'شارع الرشيدى'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                            EdgeInsets.all(2),
                                                                            height:
                                                                            50,
                                                                            width:
                                                                            110,
                                                                            decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                            EdgeInsets.all(2),
                                                                            height:
                                                                            50,
                                                                            width:
                                                                            110,
                                                                            decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                        EdgeInsets.all(5),
                                                                        height:
                                                                        50,
                                                                        width:
                                                                        130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          height:
                                                                          60,
                                                                          width:
                                                                          150,
                                                                          alignment:
                                                                          Alignment.center,
                                                                          padding:
                                                                          EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                          Text(
                                                                            'Confirm',
                                                                            style:
                                                                            TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                      Alignment.center,
                                                      padding:
                                                      EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )),
                              Marker(
                                  point: to,
                                  width: 150,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text(searchController2.text.isNotEmpty?searchController2.text:'شارع بستان الفاضل'),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_back_ios_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text('First Line'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '7:45pm',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20),
                                                      ),
                                                      Spacer(),
                                                      Text('7:05pm',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.grey,
                                                              fontSize: 20)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                  Slider(
                                                    value: 50,
                                                    onChanged: (v) {},
                                                    activeColor: Colors.blue,
                                                    min: 0,
                                                    max: 100,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text(''),
                                                      Spacer(),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      Text('موقعك'),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Total:50 EGP',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) {
                                                          return SizedBox(
                                                            height: 250,
                                                            child: AlertDialog(
                                                              content: SizedBox(
                                                                  height: 250,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                            EdgeInsets.all(2),
                                                                            height:
                                                                            50,
                                                                            width:
                                                                            110,
                                                                            decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .location_on,
                                                                                // ),
                                                                                Text(
                                                                                  '5km',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Distance',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                            EdgeInsets.all(2),
                                                                            height:
                                                                            50,
                                                                            width:
                                                                            110,
                                                                            decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
                                                                            child:
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                // Icon(
                                                                                //   Icons
                                                                                //       .watch_later,
                                                                                // ),
                                                                                Text(
                                                                                  '1 Hour',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                                Text(
                                                                                  'Time',
                                                                                  style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        30,
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                        EdgeInsets.all(5),
                                                                        height:
                                                                        50,
                                                                        width:
                                                                        130,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(15),
                                                                            border: Border.all(color: Colors.grey)),
                                                                        child:
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.price_check_outlined,
                                                                            ),
                                                                            Text(
                                                                              '25 \$',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'Prise',
                                                                              style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                        30,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          height:
                                                                          60,
                                                                          width:
                                                                          150,
                                                                          alignment:
                                                                          Alignment.center,
                                                                          padding:
                                                                          EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              borderRadius: BorderRadius.circular(15)),
                                                                          child:
                                                                          Text(
                                                                            'Confirm',
                                                                            style:
                                                                            TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 60,
                                                      width: 150,
                                                      alignment:
                                                      Alignment.center,
                                                      padding:
                                                      EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              15)),
                                                      child: Text(
                                                        'Next',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                  points: routpoints,
                                  color: Colors.blue,
                                  strokeWidth: 9)
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            isMulti = !isMulti;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              Icons.directions_rounded,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyLocationProvider {
  Location locationManager = Location();

//get user location if the service is enabled and user granted to use it on this app
  Future<LocationData?> getLocation() async {
    bool isServiceEnabled = await requestService();
    bool isPermissionGranted = await requestPermission();
    if (!isServiceEnabled || !isPermissionGranted) {
      return null;
    } else {
      return locationManager.getLocation();
    }
  }

//to check if user accept to use gps on this app
  Future<bool> isPermissionGranted() async {
    PermissionStatus permissionStatus = await locationManager.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

//gps is opened on my phone?
  Future<bool> isServiceEnabled() async {
    bool serviceEnabled = await locationManager.serviceEnabled();
    return serviceEnabled;
  }

//ask user to accept to use gps on this app
  Future<bool> requestPermission() async {
    PermissionStatus permissionStatus =
        await locationManager.requestPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

//to open gps
  Future<bool> requestService() async {
    bool serviceEnabled = await locationManager.requestService();
    return serviceEnabled;
  }

//track user location
  Stream<LocationData> trackUserLocation() {
    locationManager.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 3,
    );

    return locationManager.onLocationChanged;
  }
}

//
// import 'package:geolocator/geolocator.dart';
//
// class MyLocationProvider {
//   // Geolocator instance
//   Geolocator _geolocator = Geolocator();
//
//   // Check if location services are enabled
//   Future<bool> isServiceEnabled() async {
//     bool serviceEnabled = await _geolocator.isLocationServiceEnabled();
//     return serviceEnabled;
//   }
//
//   // Request to open location services
//   Future<bool> requestService() async {
//     bool serviceEnabled = await _geolocator.openLocationSettings();
//     return serviceEnabled;
//   }
//
//   // Check if location permission is granted
//   Future<bool> isPermissionGranted() async {
//     LocationPermission permission = await _geolocator.checkPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   // Request location permission
//   Future<bool> requestPermission() async {
//     LocationPermission permission = await _geolocator.requestPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   // Get user location if the service is enabled and user granted permission
//   Future<Position?> getLocation() async {
//     bool isServiceEnabled = await isServiceEnabled();
//     bool isPermissionGranted = await isPermissionGranted();
//     if (!isServiceEnabled || !isPermissionGranted) {
//       return null;
//     } else {
//       return await _geolocator.getCurrentPosition();
//     }
//   }
//
//   // Track user location
//   Stream<Position> trackUserLocation() {
//     return _geolocator.getPositionStream(
//       desiredAccuracy: LocationAccuracy.high,
//       intervalDuration: Duration(destinationonds: 5),
//       distanceFilter: 3,
//     );
//   }
// }
// getRoad()async{
//   var request = http.Request('GET', Uri.parse('https://419a-156-197-43-145.ngrok-free.app/Roadapi/'));
//
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   }
//   else {
//     print(response.reasonPhrase);
//   }
//
// }
