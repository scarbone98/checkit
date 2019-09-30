import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _profileSectionTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['BADGES', 'HISTORY', 'STATS']
          .asMap()
          .map(
            (i, e) => MapEntry(
              i,
              InkWell(
                child: Text(
                  e,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        _selectedIndex == i ? Colors.deepPurple : Colors.black,
                  ),
                ),
                onTap: () => setState(() => _selectedIndex = i),
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget _profileTabPages() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[Text('Badges'), Text('History'), Text('Stats')],
      ),
    );
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.15),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(0, 0),
                      blurRadius: 10.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Colors.white,
                ),
                width: double.infinity,
                height: 300,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network(
                                        'https://scontent-ort2-1.xx.fbcdn.net/v/t1.0-9/1393588_10202492791105027_691266021_n.jpg?_nc_cat=104&_nc_oc=AQk5hPf1Wn5Rv0hraRvp1_fbLH9wrA047iO6-7QloqJ8_O4JyHz47ttBAWrtlUeAOjjkhVAuOZ-VeyEzYRR6e73H&_nc_ht=scontent-ort2-1.xx&oh=5861d1dec3a16ea219a0944bbaa3f83c&oe=5E3BE477',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Samuel Carbone',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Creepo watch out for this guy',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: new Offset(0.0, 4.0),
                                        blurRadius: 5,
                                        spreadRadius: 0.5,
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      10,
                                      16,
                                      10,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '4.98',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    this._profileSectionTabs(),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )
            ],
          ),
          this._profileTabPages()
        ],
      ),
    );
  }
}
