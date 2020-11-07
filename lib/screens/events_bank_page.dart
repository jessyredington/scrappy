//Packages from Pubspec
import 'package:scrappy/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrappy/screens/event_details_page.dart';



//Internal files
import '../components/icon_content.dart';
import '../components/reusable_card.dart';
import '../constants.dart';
import 'filters_page.dart';
import 'package:scrappy/services/event_service.dart';
import 'package:scrappy/models/event.dart';
import 'package:scrappy/models/events_bank.dart';
import 'package:scrappy/components/nav_bar.dart';
import 'package:scrappy/screens/calendar_page.dart';

const CCSE_hori_Logo='images/KSU_on light backgrounds/KSU_SVG LOGO/BE_Horiz_2Clr_Computing and Software.svg';


class EventsBankPage extends StatefulWidget {
  static const String id = '/event_bank';
  final Event leadEvent;
  final List<Event> eventBankVault;
  final Filters eventFilters;
  EventsBankPage({this.leadEvent, this.eventBankVault, this.eventFilters});

  @override
  _EventsBankPageState createState() => _EventsBankPageState();
}

class _EventsBankPageState extends State<EventsBankPage> {
  var eventService = EventService();
  EventBank eventBank;
  Event topEvent;
  Filters filtersForEvents;
  List<Event> vault;
  int length;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.leadEvent, widget.eventBankVault, widget.eventFilters);
  }

  void updateUI( Event leadEvent, List<Event> eventBankVault, Filters eventFilters) {
    setState(() {
      topEvent = leadEvent;
      vault = eventBankVault;
      length = vault.length;
      filtersForEvents = eventFilters;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Navbar(),

      body:SafeArea(
        child: Scrollbar(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height:100.0,
                  color: Colors.amber.shade200,

                  child: Row(
                    children: [
                      Expanded(child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0,),),
                          Align(
                              alignment: Alignment.center,
                              child: Image(
                                image:AssetImage('images/KSU_on light backgrounds/KSU_PNG LOGO/BE_Horiz_3Clr_Computing and Software.png'),

                                width: 250.0 ,
                              ),
                          ),
                          Padding(padding: EdgeInsets.only(left:16.0,)),
                          Expanded(
                            // alignment: Alignment.centerRight,
                            child: RawMaterialButton(
                              elevation: 2.0,
                              fillColor: kCardColor,
                              child: Icon(
                                FontAwesomeIcons.calendarAlt,
                                size: 35.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                              // onPressed: () => Navigator.pushReplacementNamed(context, CalendarPage.id),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return CalendarPage();
                                }));
                              },

                            )
                          ),
                        ],
                      )
                      ),
                    ],
                  )
              ),
              
              Row(
                  children: [
                    Expanded(
                        child: RaisedButton.icon(
                            color: kCardColor,
                            icon: Icon(FontAwesomeIcons.filter),
                            label: Text('Select Filters',
                              style: TextStyle(fontSize: 20.0),)
                            ,
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                    return FiltersPage(filters: filtersForEvents );
                                  }
                                  )
                              );
                            })
                    )
                  ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:30.0,top:10.0),),
                  Text('Current Happenings', style:TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0 ,color: kCardColor)),

                ],
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return EventDetailsPage(event:topEvent);
                      }))
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageCard(event: topEvent),
                        ),
                      ),
                    ),
                  ),
              ),
              Expanded(
                  child: GridView.builder(
                  itemCount: length - 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0
                  ),
                  itemBuilder: (BuildContext content, int index){
                    return ImageCard(event: vault[index]);
                  },
                )
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      color: Colors.white,
      child:Column(
        children: <Widget>[
                Row(
                  children:[
                    FittedBox(
                      fit:BoxFit.contain,
                      child: Image.network(event.photo_url),
                    ),
                  ]
                ),
                Row(
                  children: [
                    Text("From: " + Jiffy(event.first_date).yMMMd,  style: TextStyle(color: Colors.black87)),
                    Text(" - To: " + Jiffy(event.last_date).yMMMd, style: TextStyle(color: Colors.black87)),
                  ],
                )
                ],
      )
    );
  }
}