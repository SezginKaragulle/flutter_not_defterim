import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_not_defterim/kategori_islemleri.dart';
import 'package:flutter_not_defterim/models/kategori.dart';
import 'package:flutter_not_defterim/not_detay.dart';
import 'package:flutter_not_defterim/utils/database_helper.dart';
import 'package:flutter_not_defterim/not_detay.dart';

import 'models/notlar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotListesi(),
    );
  }
}

//Notların Listeleneceği ekranın tasarımı
class NotListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text("Not Sepeti"),
        ),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context){
       return [
      PopupMenuItem(child: ListTile(leading: Icon(Icons.category),title: Text("Kategoriler"),onTap: _kategorilerSayfasinaGit(context),)),
         
       ];
          }),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: "Kategori Ekle",
            heroTag: "Kategori Ekle",
            onPressed: () {
              kategoriEkleDialog(context);
            },
            child: Icon(Icons.category),
            mini: true,
          ),
          FloatingActionButton(
            tooltip: "Not Ekle",
            heroTag: "Not Ekle",
            onPressed: () => _detaySayfasinaGit(context),
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

//Kategori EKleme Kodu
  void kategoriEkleDialog(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: <Widget>[
              Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (yeniDeger) {
                        yeniKategoriAdi = yeniDeger;
                      },
                      decoration: InputDecoration(
                          labelText: "Kategori Adı",
                          border: OutlineInputBorder()),
                      validator: (girilenKategoriAdi) {
                        if (girilenKategoriAdi.length < 3) {
                          return "En Az 3 karakter giriniz";
                        }
                      },
                    ),
                  )),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //Kategori Kaydetme İşlemi

                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Kategori Eklendi"),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni Not",
                )));
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Kategoriler()));

  }
}



class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: databaseHelper.notListesiniGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumNotlar = snapShot.data;
            sleep(Duration(milliseconds: 500));
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                      title: Text(
                    tumNotlar[index].notBaslik,),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: <Widget>[
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Kategori",style: TextStyle(color: Colors.blue),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(tumNotlar[index].kategoriBaslik,style: TextStyle(color: Colors.black),),
                            ),
                          ],),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Oluşturulma Tarihi",style: TextStyle(color: Colors.blue),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(databaseHelper.dateFormat(DateTime.parse(tumNotlar[index].notTarih)),style: TextStyle(color: Colors.black),),
                            ),
                          ],),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(tumNotlar[index].notIcerik,style: TextStyle(fontSize: 20),),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                            FlatButton(onPressed: ()=>_notSil(tumNotlar[index].notID), child: Text("Sil",style: TextStyle(color: Colors.blue),)),
                            FlatButton(onPressed: (){
                              _detaySayfasinaGit(context, tumNotlar[index]);

                            }, child: Text("Güncelle",style: TextStyle(color:Colors.blue),)),
                          ],)
                        ],
                      ),

                    ),
                    ],
                  );
                });
          } else {

            return Center(
              child: Text("Yükleniyor..."),

            );
          }
        });
  }
  _detaySayfasinaGit(BuildContext context,Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
              baslik: "Notu Düzenle",
              duzenlenecekNot :not
            )));
  }

  _oncelikIconuAta(int notOncelik) {

    switch(notOncelik)
    {
      case 0:
        return CircleAvatar(child: Text("AZ",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue.shade100,);
        break;
      case 1:
        return CircleAvatar(child: Text("ORTA",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue.shade400,);
        break;
      case 2:
        return CircleAvatar(child: Text("ÇOK",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue.shade700,);
        break;
    }
  }

  _notSil(int notID) {

    databaseHelper.notSil(notID).then((silinenID)
    {
     if(silinenID!=0)
       {
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Not Silindi")));
       }
     setState(() {

     });
    });
  }
}
