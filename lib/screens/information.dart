import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Know your Municipality"),
        backgroundColor: Color.fromARGB(255, 21, 76, 121),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new DropdownTiles(listOfTiles[index]);
        },
        itemCount: listOfTiles.length,
      ),
    );
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listOfTiles = <MyTile>[
  MyTile("Civic Agencies", <MyTile>[
    MyTile("BBMP", <MyTile>[
      MyTile("The Bruhat Bengaluru Mahanagara Palike is is the administrative body " +
          "responsible for civic amenities and some infrastructural assets of the Greater Bangalore metropolitan area.")
    ]),
    MyTile("BWSSP",
        <MyTile>[MyTile("The Bengaluru Water Supply is the department for")]),
    MyTile("BESCOM", <MyTile>[
      MyTile(
          "The Bengaluru Electric Supply and communication organization management")
    ])
  ]),
  MyTile("Departments", <MyTile>[
    MyTile("Electricity", <MyTile>[
      MyTile(
          "BESCOM – Bangalore Electricity Supply Company Limited is responsible for Power distribution in Eight districts of Karnataka (Bangalore Urban, Bangalore Rural, Chikkaballapura, Kolar, Davanagere, Tumkur, Chitradurga and Ramanagara).",
          <MyTile>[
            MyTile("Chief Engineer: Sri.Sriramegowda"),
            MyTile("HelpLine Number: 	080-22085093"),
            MyTile("Email: md@bescom.co.in")
          ])
    ]),
    MyTile("Sewage", <MyTile>[
      MyTile(
          "BWSSP or The Bangalore Water Supply and Sewerage Board is the premier governmental agency responsible for sewage disposal and water supply to the Indian city of Bangalore.",
          <MyTile>[
            MyTile("Chief Engineer: Sri.Chandrashekar"),
            MyTile("HelpLine Number: 	080-22085093"),
            MyTile("Email: md@bescom.co.in")
          ])
    ]),
    MyTile("Infrastructure", <MyTile>[
      MyTile(
          "Bengaluru Metropolitan Region Development Authority (BMRDA) is an autonomous body created by the Government of Karnataka under the BMRDA Act 1985 for the purpose of planning, co-ordinating and supervising the proper and orderly development of the areas within the Bangalore Metropolitan Region (BMR).",
          <MyTile>[
            MyTile("Chief Engineer: Sri.Ramesh"),
            MyTile("HelpLine Number: 	080-22085093"),
            MyTile("Email: md@bescom.co.in")
          ])
    ]),
    MyTile("Urban Development", <MyTile>[
      MyTile(
          "Karnataka Urban Infrastructure Development and Finance Corporation (KUIDFC) was incorporated as a public limited company under the Companies Act, 1956 on 02.11.1993 with the objects to prepare, formulate and implement projects, schemes and programmes relating to infrastructure development in the urban areas",
          <MyTile>[
            MyTile("Chief Engineer: Sri.Suresh"),
            MyTile("HelpLine Number: 	080-22085093"),
            MyTile("Email: md@bescom.co.in")
          ])
    ]),
  ])
];

class DropdownTiles extends StatelessWidget {
  final MyTile myTile;
  DropdownTiles(this.myTile);
  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile T) {
    if (T.children.isEmpty) {
      return ListTile(title: Text(T.title));
    }
    return ExpansionTile(
        key: PageStorageKey<MyTile>(T),
        title: Text(T.title),
        children: T.children.map(_buildTiles).toList());
  }
}
