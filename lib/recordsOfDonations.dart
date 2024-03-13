import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KorisnikPocetna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Korisnik Početna'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('evidencija_dolazaka')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Došlo je do greške: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // Ovdje možete oblikovati kako želite prikazati podatke iz dokumenta
              return ListTile(
                title: Text('Datum: ${data['datum']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mjesto: ${data['mjesto']}'),
                    Text(
                        'Ime i prezime liječnika: ${data['ime_prezime_lijecnika']}'),
                    Text(
                        'Ime i prezime tehničara: ${data['ime_prezime_tehnicara']}'),
                    Text('Krvni tlak: ${data['krvni_tlak']}'),
                    Text('Odbijeno darivanje: ${data['odbijeno_darivanje']}'),
                    Text('Razlog odbijanja: ${data['razlog_odbijanja']}'),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
