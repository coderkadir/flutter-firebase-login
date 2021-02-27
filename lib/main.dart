import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _mesaj = "";

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          _mesaj = "\nListener TETİKLENDİ user sign in ";
        } else {
          _mesaj = "\nLİSTENER TETİKLENDİ USER OUT!";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase Login by CK"),
        backgroundColor: Colors.teal.shade400,
        shadowColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              "Üye Ol",
              style: TextStyle(fontSize: 17, color: Colors.teal.shade200),
            ),
            onPressed: _emailfirebasecreate,
          ),
          TextButton(
            child: Text(
              "Giriş Yap",
              style: TextStyle(fontSize: 17, color: Colors.lightBlue),
            ),
            onPressed: _emailfirebaselogin,
          ),
          TextButton(
            child: Text(
              "Çıkış Yap",
              style: TextStyle(fontSize: 17, color: Colors.redAccent),
            ),
            onPressed: _cikisYap,
          ),
          TextButton(
            child: Text(
              "Şifremi unuttum",
              style: TextStyle(fontSize: 17, color: Colors.amber),
            ),
            onPressed: _sifremiunuttum,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(_mesaj),
          )
        ],
      ),
    );
  }

  Future<void> _emailfirebasecreate() async {
    String mail = "kadirjbs@gmail.com";
    String sifre = "qevdvJwNb53h3w8";
    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(email: mail, password: sifre)
        .catchError((e) => debugPrint("Hata" + e));
    if (firebaseUser != null) {
      firebaseUser.user
          .sendEmailVerification()
          .then((value) {})
          .catchError((e) {
        debugPrint("HATA MESAJI MAİL GÖNDERİLEMEDİ $e".toString());
      });

      setState(() {
        _mesaj +=
            "\nKullanıcı UID  ${firebaseUser.user.uid} \n mail :  ${firebaseUser.user.email} \n Mail Onayı: ${firebaseUser.user.emailVerified}";
      });
    }
  }

  void _emailfirebaselogin() async {
    String mail = "kadirjbs@gmail.com";
    String sifre = "qevdvJwNb53h3w8";
    _auth
        .signInWithEmailAndPassword(email: mail, password: sifre)
        .then((oturumacmiskullanici) => {
              if (oturumacmiskullanici.user.emailVerified == true)
                {
                  setState(() {
                    _mesaj += "\n OTURUM BAŞARILI";
                  })
                }
              else
                {
                  setState(() {
                    _mesaj += "\n OTURUM Başarısız Mail kutuna bak";
                  })
                }
            })
        .catchError((e) {
      debugPrint("GİRİŞ HATASI $e".toString());
    });
  }

  void _cikisYap() async {
    _auth.signOut().then((value) {
      setState(() {
        _mesaj += "\nÇıkış yapıldı";
      });
    });
  }

  void _sifremiunuttum() async {
    String mail = "kadirjbs@gmail.com";
    _auth.sendPasswordResetEmail(email: mail).then((value) => {
          setState(() {
            _mesaj += "\n MAİL GÖNDERİLDİ";
          })
        });
  }
}
