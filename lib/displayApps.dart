import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcherapp/customizeHome.dart';
import 'package:launcherapp/main.dart';

class DisplayApps extends StatefulWidget {
  @override
  _DisplayAppsState createState() => _DisplayAppsState();
}

class _DisplayAppsState extends State<DisplayApps> {
  Future<List<Application>> getApps() async {
    // DeviceApps.
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    return apps;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() async {
    // ScrollPosition position = _controller.position;
    // print(_controller.position.minScrollExtent == _controller.offset);
    // print(_controller.position.maxScrollExtent);

    //  if (_controller.position.extentAfter < someThreshold) {
    //   _dummyFunction()
    // }
  }

  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text("All Apps"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: new DropdownButton<String>(
              // itemHeight: 50,
              iconEnabledColor: Colors.white,
              autofocus: false,
              hint: Text(""),
              focusColor: Colors.white,
              icon: Icon(Icons.more_vert_rounded),
              items: [
                DropdownMenuItem<String>(
                  child: GestureDetector(
                    child: Text(
                      "Add Icons to HomePage",
                      style: TextStyle(
                        color: Colors.black,
                        // fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomizeHomePage(),
                          ));
                    },
                  ),
                )
              ],
              underline: SizedBox(),
              onChanged: (_) {},
            ),
            // child: Icon(Icons.more_vert_rounded),
          )
        ],
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade800.withOpacity(0.3),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            print(details.delta);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: getApps(),
                builder: (context, snapshot) {
                  // DeviceApps.
                  return snapshot.hasData
                      ? Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.all(8.0),
                            // physics: const BouncingScrollPhysics(
                            //     parent: AlwaysScrollableScrollPhysics()), // new
                            controller: _controller,
                            itemCount: snapshot.data.length,

                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  snapshot.data[index].openApp();
                                },
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 13),
                                dense: true,
                                title:
                                    snapshot.data[index] is ApplicationWithIcon
                                        ? Image.memory(
                                            snapshot.data[index].icon,
                                            height: 40,
                                          )
                                        : Text(""),
                                subtitle: Container(
                                  width: 200,
                                  child: Text(
                                    (snapshot.data[index].appName
                                                .toString()
                                                .length >=
                                            14)
                                        ? snapshot.data[index].appName
                                                .toString()
                                                .substring(0, 14) +
                                            ".."
                                        : snapshot.data[index].appName
                                            .toString(),
                                    textAlign: TextAlign.center,

                                    // snapshot.data[index].appName.toString(),
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              crossAxisCount: 4,
                            ),
                          ),
                        )
                      : Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              accentColor: Colors.amber[300],
                            ),
                            child: CircularProgressIndicator(),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
