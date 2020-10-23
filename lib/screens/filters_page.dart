import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scrappy/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'package:scrappy/components/Nav_Bar.dart';
import 'package:scrappy/screens/events_bank_page.dart';
import 'package:scrappy/services/event_service.dart';
import "package:scrappy/models/event.dart";
import 'package:scrappy/screens/loading_screen.dart';



class FiltersPage extends StatefulWidget {
  static const String id = '/filters';
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  //bool _isChecked = true;
  EventService eventService = EventService();
  List<EventTargetAudience> audiences;
  List<EventType> types;

  void onChanged(bool value, item){
    setState(() {
          item.isChecked = !item.isChecked;
    });
  }

  void getEventFilters() async{
      Filters filters = await eventService.getEventsFilters();
      types = filters.event_types;
      audiences = filters.event_target_audience;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventFilters();
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Navbar(),
        appBar:AppBar(
            title: Text('Event Tags')
        ),
        body: FutureBuilder<Filters>(
          future: eventService.getEventsFilters(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return new Container(

                child: Column(

                  children:<Widget>[

                    Padding(
                        padding: EdgeInsets.only(top: 10.0)),

                    Text("Event Types", style: kLabelTextStyle2,),


                    Expanded(

                        child: ListView.builder(
                            itemCount: types.length - 1,
                            itemBuilder: (BuildContext content, int index){
                              return new CheckboxListTile(
                                  title: new Text(types[index].name, style: kLabelTextStyle),
                                  activeColor: Colors.amberAccent,
                                  secondary: const Icon(FontAwesomeIcons.checkCircle),
                                  value: types[index].isChecked,
                                  onChanged: (bool value){onChanged(value, types[index]);});
                            },
                        )),
                    Text("Event Target Audience", style: kLabelTextStyle2,),
                    Expanded(

                        child: ListView.builder(
                          itemCount: audiences.length - 1,
                          itemBuilder: (BuildContext content, int index){
                            return new CheckboxListTile(
                                title: new Text(audiences[index].name, style: kLabelTextStyle),
                                activeColor: Colors.amberAccent,
                                secondary: const Icon(FontAwesomeIcons.checkCircle),
                                value: audiences[index].isChecked,
                                onChanged: (bool value){onChanged(value, audiences[index]);});
                          },
                        )),
                    Row(
                      children: [
                        Expanded(child:
                          RaisedButton.icon(
                            color: kCardColor,
                            icon: Icon(FontAwesomeIcons.filter),
                            label: Text('Submit Filters',
                              style: TextStyle(fontSize: 20.0),)
                            ,
                            onPressed: (){
                              List submitFilters  = List();
                              types.forEach((type) =>
                              {
                                if(type.isChecked){submitFilters.add(type.id)}
                              });
                              audiences.forEach((audience) => {
                                if(audience.isChecked){submitFilters.add(audience.id)}
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                    return LoadingScreen(filters: submitFilters,);
                                  }
                                  )
                              );
                            })
                        )
                      ],
                    )

                  ],
                ),
              );
            }else{
              return CircularProgressIndicator();
            }
          },
        ),

      ),
    );
  }
}
