import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/travel.dart';
import '../widgets/travel_view.dart';
import '../services/database.dart';
import 'travel_add_page.dart';

class TravelListings extends StatelessWidget {
  const TravelListings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: getTravels(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Bir hatayla karşılaşıldı');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator()
                )
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document) {
                Travel travel = Travel.fromMap(document.data() as Map<String, dynamic>);

                return TravelView(travel);
              }).toList(),
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TravelAddPage(),));
            },
          )
        )
      ]
    );
  }
}


