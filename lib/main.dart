import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:launcherapp/displayApps.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  List<String> selectedApps = [];
  MyApp({this.selectedApps});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    permissionstatus();
    super.initState();
    // getIconsdata();
    // try {
    //   print(widget.selectedApps == null);
    // } catch (e) {
    //   print(e);
    // }
  }

  var wallpaper;
  getWallPaper() async {
    LauncherAssist.getWallpaper().then((data) {
      setState(() {
        wallpaper = data;
      });
    });
  }

  Future<List> getApps() async {
    // DeviceApps.
    List apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    // app
    return apps;
  }

  List iconDataLIst = [];

  getIconsdata() {
    getApps().then(
      (value) => {
        // print()

        if (widget.selectedApps != null)
          {
            for (var app in value)
              {
                if (widget.selectedApps.indexOf(app.appName.toString()) != -1)
                  {
                    // print(List.from(app.icon)),

                    setState(() {
                      iconDataLIst.add((List.from(app.icon)).runtimeType);
                    }),
                    // print(app.icon.toList())
                  }
              }
          }
      },
    );

    // return iconDataLIst;
  }

  // List<Application> appsList;
  permissionstatus() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isDenied) {
      permissionstatus();
    }
  }

  bool floatTap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.grey.shade800,
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // floatTap ??
          setState(() {
            floatTap = false;
          });
          if (details.delta.direction < 0) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: DisplayApps()));
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: wallpaper != null
                  ? Image.memory(
                      wallpaper,
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey.shade800),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ">",
                      style: TextStyle(color: Colors.amber[300], fontSize: 90),
                    ),
                    Text(
                      " Launcher",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                ),
                !floatTap
                    ? widget.selectedApps != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            height: MediaQuery.of(context).size.height * 0.076,
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: FutureBuilder(
                                future: DeviceApps.getInstalledApplications(
                                  includeAppIcons: true,
                                  includeSystemApps: true,
                                  onlyAppsWithLaunchIntent: true,
                                ),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.selectedApps.length,
                                          itemBuilder: (context, index) {
                                            if (widget.selectedApps.indexOf(
                                                    snapshot.data[index].appName
                                                        .toString()) ==
                                                -1) {
                                              return GestureDetector(
                                                onTap: () {
                                                  snapshot.data[index]
                                                      .openApp();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 30),
                                                  child: Center(
                                                    child: snapshot.data[index]
                                                            is ApplicationWithIcon
                                                        ? Image.memory(
                                                            snapshot.data[index]
                                                                .icon,
                                                            height: 40,
                                                          )
                                                        : Text("Nothing"),
                                                  ),
                                                ),
                                              );
                                            }
                                            // if (widget.selectedApps.indexOf(app.appName.toString()) != -1)
                                          },
                                        )
                                      : Center(
                                          child: Theme(
                                              data: Theme.of(context).copyWith(
                                                accentColor: Colors.amber[300],
                                              ),
                                              child:
                                                  CircularProgressIndicator()));
                                }),
                          )
                        : Container()
                    : Container(),
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[300],
        child: Text(
          !floatTap ? ">" : "<",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          widget.selectedApps != null ? getIconsdata() : print("null");
          setState(() {
            floatTap = !floatTap;
          });
        },
      ),
    );
  }
}
