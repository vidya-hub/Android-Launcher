import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:launcherapp/main.dart';

class CustomizeHomePage extends StatefulWidget {
  @override
  _CustomizeHomePageState createState() => _CustomizeHomePageState();
}

class _CustomizeHomePageState extends State<CustomizeHomePage> {
  List<Map> appList = [];
  List<bool> checkBoxvalues = [];
  Future<List> getApps() async {
    List apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    for (var app in apps) {
      setState(() {
        appList.add({app.appName: false});
        checkBoxvalues.add(false);
      });
    }
    return apps;
  }

  List<String> selectedApps = [];

  @override
  void initState() {
    getApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Add Apps To Home Screen"),
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade800,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: appList.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()), // new
                      itemCount: appList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(
                            appList[index].keys.toList()[0].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Checkbox(
                                checkColor: Colors.black,
                                activeColor: Colors.amber[300],
                                value: appList[index].values.toList()[0],
                                onChanged: (bool value) {
                                  setState(() {
                                    appList[index][appList[index]
                                        .keys
                                        .toList()[0]
                                        .toString()] = value;
                                    checkBoxvalues.removeAt(index);
                                    checkBoxvalues.insert(
                                        index,
                                        appList[index][appList[index]
                                            .keys
                                            .toList()[0]
                                            .toString()]);
                                    if (value &&
                                        selectedApps.indexOf(appList[index]
                                                .keys
                                                .toList()[0]
                                                .toString()) ==
                                            -1) {
                                      print(selectedApps.indexOf(appList[index]
                                          .keys
                                          .toList()[0]
                                          .toString()));
                                      selectedApps.add(appList[index]
                                          .keys
                                          .toList()[0]
                                          .toString());
                                    }
                                    print(selectedApps);
                                  });
                                  setState(() {});
                                }),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          accentColor: Colors.amber[300],
                        ),
                        child: CircularProgressIndicator(
                            // valueColor: ,
                            ),
                      ),
                    ),
            ),
            !checkBoxvalues.contains(true)
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MyApp(
                            selectedApps: selectedApps,
                          );
                        },
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        child: Center(
                            child: Text(
                          "Done",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[300],
                        ),
                        // Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
