import 'package:covidtrack/screens/india_stats_detail_page.dart';
import 'package:covidtrack/screens/loading_screen.dart';
import 'package:covidtrack/screens/state_select_page.dart';
import 'package:covidtrack/utils/constants.dart';
import 'package:covidtrack/utils/models/state_data.dart';
import 'package:covidtrack/utils/models/state_list.dart';
import 'package:covidtrack/utils/navigation_transition.dart';
import 'package:covidtrack/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class IndiaHomePage extends StatefulWidget {
  @override
  _IndiaHomePageState createState() => _IndiaHomePageState();
}

class _IndiaHomePageState extends State<IndiaHomePage> {
  StateList stateList;
  List<StateData> stateDataList;
  Map<String, StateData> dataMap;
  StateData mostCases, mostDeaths, mostRecovered, totalData;
  bool load = false, showAll = true, showNew = true, showStats = false;
  String indiaFlagUrl = 'http://www.geognos.com/api/en/countries/flag/IN.png';
  IconData showAllIcon, showNewIcon, showStatsIcon;
  @override
  void initState() {
    stateList = StateList();
    stateDataList = List();
    super.initState();
    showStatsIcon = showNewIcon = showAllIcon = Icons.expand_less;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(),
      body: SafeArea(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 15, top: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Image.asset(
                                    kGermImage,
                                    width: 50,
                                  ),
                                ),
                                Text(
                                  'INDIA',
                                  style: kHeaderTextStyle,
                                ),
                                Tooltip(
                                  message: 'Search States',
                                  child: GestureDetector(
                                    onTap: () {
                                      toStateSearchPage();
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.only(right: 8),
                                      child: Material(
                                          color: Colors.white70,
                                          type: MaterialType.circle,
                                          elevation: 4,
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.black,
                                            size: 35,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CaseCard(
                          totalCases: totalData.totalConfirmed,
                          isFlag: true,
                          flagURL: indiaFlagUrl,
                          color: colorArray['purple'],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                'All Cases',
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Merienda'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showAll = !showAll;
                                  if (showAll)
                                    showAllIcon = Icons.expand_less;
                                  else
                                    showAllIcon = Icons.expand_more;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(
                                    showAllIcon,
                                    size: 35,
                                  )),
                            )
                          ],
                        ),
                        showAll
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DataListTile(
                                    color: Colors.deepPurple,
                                    cases: totalData.totalActive,
                                    text: 'Active',
                                  ),
                                  DataListTile(
                                    color: Colors.green,
                                    cases: totalData.totalRecovered,
                                    text: 'Recovered',
                                  ),
                                  DataListTile(
                                    color: Colors.red,
                                    cases: totalData.totalDeaths,
                                    text: 'Deaths',
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8, 10, 8, 10),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding:
                                              EdgeInsets.fromLTRB(8, 13, 8, 13),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              PercentDataCard(
                                                title: 'Active',
                                                number: ((totalData
                                                                .totalActive /
                                                            totalData
                                                                .totalConfirmed) *
                                                        100)
                                                    .toStringAsFixed(2),
                                                color: Colors.deepPurple,
                                              ),
                                              Divider(),
                                              PercentDataCard(
                                                title: 'Recovered',
                                                number: ((totalData
                                                                .totalRecovered /
                                                            totalData
                                                                .totalConfirmed) *
                                                        100)
                                                    .toStringAsFixed(2),
                                                color: Colors.green,
                                              ),
                                              Divider(),
                                              PercentDataCard(
                                                title: 'Death',
                                                number: ((totalData
                                                                .totalDeaths /
                                                            totalData
                                                                .totalConfirmed) *
                                                        100)
                                                    .toStringAsFixed(2),
                                                color: Colors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.2,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    margin:
                                        EdgeInsets.only(top: 12, bottom: 15),
                                    padding: EdgeInsets.all(8),
                                    child: PieChart([
                                      Case(
                                          type: 'Active',
                                          value: totalData.totalActive,
                                          colorValue: Color(0xff2962ff)),
                                      Case(
                                          type: 'Recovered',
                                          value: totalData.totalRecovered,
                                          colorValue: Color(0xff4caf50)),
                                      Case(
                                          type: 'Death',
                                          value: totalData.totalDeaths,
                                          colorValue: Color(0xffff1744)),
                                    ], true),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 8,
                              ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                'New Cases',
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Merienda'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showNew = !showNew;
                                  if (showNew)
                                    showNewIcon = Icons.expand_less;
                                  else
                                    showNewIcon = Icons.expand_more;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(
                                    showNewIcon,
                                    size: 35,
                                  )),
                            )
                          ],
                        ),
                        showNew
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DataListTile(
                                    color: Colors.deepPurple,
                                    cases: totalData.newConfirmed,
                                    text: 'Confirmed',
                                  ),
                                  DataListTile(
                                    color: Colors.green,
                                    cases: totalData.newRecovered,
                                    text: 'Recovered',
                                  ),
                                  DataListTile(
                                    color: Colors.red,
                                    cases: totalData.newDeaths,
                                    text: 'Deaths',
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 13, 8, 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            PercentDataCard(
                                              title: 'New Active',
                                              number: ((totalData.newConfirmed /
                                                          totalData
                                                              .totalConfirmed) *
                                                      100)
                                                  .toStringAsFixed(2),
                                              color: Colors.deepPurple,
                                            ),
                                            Divider(),
                                            PercentDataCard(
                                              title: 'New Recovered',
                                              number: ((totalData.newRecovered /
                                                          totalData
                                                              .totalConfirmed) *
                                                      100)
                                                  .toStringAsFixed(2),
                                              color: Colors.green,
                                            ),
                                            Divider(),
                                            PercentDataCard(
                                              title: 'New Death',
                                              number: ((totalData.newDeaths /
                                                          totalData
                                                              .totalDeaths) *
                                                      100)
                                                  .toStringAsFixed(2),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      margin:
                                          EdgeInsets.only(top: 8, bottom: 15),
                                      padding: EdgeInsets.all(18),
                                      child: Column(
                                        children: <Widget>[
                                          Text('New Cases'),
                                          Expanded(
                                            child: BarChart([
                                              Case(
                                                  type: 'Confirmed',
                                                  value: totalData.newConfirmed,
                                                  barColor: charts.ColorUtil
                                                      .fromDartColor(
                                                          Colors.deepPurple)),
                                              Case(
                                                  type: 'Recovered',
                                                  value: totalData.newRecovered,
                                                  barColor: charts.ColorUtil
                                                      .fromDartColor(
                                                          Colors.green)),
                                              Case(
                                                  type: 'Death',
                                                  value: totalData.newDeaths,
                                                  barColor: charts.ColorUtil
                                                      .fromDartColor(
                                                          Colors.red)),
                                            ]),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 8,
                              ),
                        Divider(),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Text(
                                'Statistics',
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Merienda'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showStats = !showStats;
                                  if (showStats)
                                    showStatsIcon = Icons.expand_less;
                                  else
                                    showStatsIcon = Icons.expand_more;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Icon(
                                    showStatsIcon,
                                    size: 35,
                                  )),
                            )
                          ],
                        ),
                        showStats
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 3),
                                    child: Text(
                                      'Most Cases',
                                      style: kPrimaryTextStyle,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      toScreen(context, 'cases', stateDataList);
                                    },
                                    child: DataCard(
                                      color: Colors.amber,
                                      countryUrl:
                                          'http://www.geognos.com/api/en/countries/flag/IN.png',
                                      countryName: snapshot.data['cases'].name,
                                      totalData:
                                          snapshot.data['cases'].totalConfirmed,
                                      newData:
                                          snapshot.data['cases'].newConfirmed,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 3),
                                    child: Text(
                                      'Most Recovered',
                                      style: kPrimaryTextStyle,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      toScreen(
                                          context, 'recovered', stateDataList);
                                    },
                                    child: DataCard(
                                      color: Colors.greenAccent,
                                      countryUrl:
                                          'http://www.geognos.com/api/en/countries/flag/IN.png',
                                      countryName:
                                          snapshot.data['recovered'].name,
                                      totalData: snapshot
                                          .data['recovered'].totalRecovered,
                                      newData: snapshot
                                          .data['recovered'].newRecovered,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 3),
                                    child: Text(
                                      'Most Deaths',
                                      style: kPrimaryTextStyle,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      toScreen(
                                          context, 'deaths', stateDataList);
                                    },
                                    child: DataCard(
                                      color: Colors.redAccent,
                                      countryUrl:
                                          'http://www.geognos.com/api/en/countries/flag/IN.png',
                                      countryName: snapshot.data['deaths'].name,
                                      totalData:
                                          snapshot.data['deaths'].totalDeaths,
                                      newData:
                                          snapshot.data['deaths'].newDeaths,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 20,
                              ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 3,
                          padding: EdgeInsets.all(20),
                          color: Colors.deepPurple,
                          child: Text(
                            'Statewise Data',
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                          onPressed: () {
                            toStateSearchPage();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.hasError) {
                return ErrorScreen();
              } else {
                return LoaderScreen();
              }
            }),
      ),
    );
  }

  Future getData() async {
    if (!load) {
      var data;
      data = await stateList.getAllStateData();
      setState(() {
        stateDataList = data.stateList;
        totalData = data.totalData;
      });

      mostCases = await stateList.getMost('cases');
      mostDeaths = await stateList.getMost('deaths');
      mostRecovered = await stateList.getMost('recovered');

      setState(() {
        dataMap = {
          'cases': mostCases,
          'recovered': mostRecovered,
          'deaths': mostDeaths
        };
        load = true;
      });
    }
    return dataMap;
  }

  void toScreen(BuildContext context, String type, var data) async {
    await Navigator.push(
        context,
        SlideRoute(
            widget: IndiaStatDetail(
          type: type,
          data: data,
        )));
  }

  void toStateSearchPage() {
    Navigator.push(context, SlideRoute(widget: StateSelectPage()));
  }
}
