import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:network_security/signUp.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:ninja_prime/ninja_prime.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SignUp()
      //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int gcd(int a, int b){
    a = a.abs();
    b = b.abs();
    //If a<b then interchange a and b
    if(a<b){
      late int t;
      t = a;
      a = b;
      b = t;
    }

    //replace a = b and b = a%b
    while(b != 0 ){
      a = b;
      b = a % b;
    }

    //return the gcd
    return a;
  }

  // int genRandE(int totient){
  //   Random random = Random();
  //   int e = random.nextInt(totient) + 1;
  //   int g = e.gcd(totient);
  //   //check if e and totient are coprime
  //   while(g != 1){
  //     e = random.nextInt(totient) + 1;
  //     g = e.gcd(totient);
  //   }
  //   return e;
  // }

  BigInt genRandE(BigInt totient){
    BigInt e = randomBigInt(511);
    BigInt g = e.gcd(totient);
    while(g != BigInt.from(1)){
      e = randomBigInt(511);
      g = e.gcd(totient);
    }
    return e;
  }




  // int exteuclid(int a, int b){
  //   int x = 0;
  //   int old_x = 1;
  //   int y = 1;
  //   int old_y = 0;
  //
  //   while(b != 0){
  //     int quotient = (a/b).floor();
  //     int t;
  //     int t_oldx,t_oldy;
  //     t = a;
  //     a = b;
  //     b = t - quotient * b;
  //     t_oldx = old_x;
  //     old_x = x;
  //     x = t_oldx - quotient * x;
  //     t_oldy = old_y;
  //     old_y = y;
  //     y = t_oldy - quotient * y;
  //
  //
  //   }
  //   return old_x;
  // }

  BigInt exteuclid(BigInt a, BigInt b){
    BigInt x = BigInt.from(0);
    BigInt old_x = BigInt.from(1);
    BigInt y = BigInt.from(1);
    BigInt old_y = BigInt.from(0);

    while(b != BigInt.from(0)){
      BigInt quotient = a ~/ b;
      BigInt t, t_oldx, t_oldy;
      t = a;
      a = b;
      b = t - quotient * b;
      t_oldx = old_x;
      old_x = x;
      x = t_oldx - quotient * x;
      t_oldy = old_y;
      old_y = y;
      y = t_oldy - quotient * y;
      
    }
    return old_x;

  }

  void encrypt(){
    print("Encrypt running");
    String msg = "Shahbaz";
    // int p = randomPrimeBigInt(9).toInt();
    // int q = randomPrimeBigInt(9).toInt();
    BigInt p = randomPrimeBigInt(512);
    BigInt q = randomPrimeBigInt(512);
    print("p = $p");
    print("q = $q");
    while(p == q || p.toString().length == q.toString().length){
      p = randomPrimeBigInt(512);
      q = randomPrimeBigInt(512);

      print("p = $p");
      print("q = $q");


    }

    // int p = 89;
    // int q = 97;
    //BigInt n = p * q * (p-BigInt.from(1)) * (q-BigInt.from(1));
    BigInt n = p * q;
    BigInt m = p * q;
    int r = randomPrimeBigInt(12).toInt();
    print("r = $r");
    while( BigInt.from(2).pow(r) < p || BigInt.from(2).pow(r) < q){
      print("r = $r");
      r = randomPrimeBigInt(12).toInt();
    }




    //computing totient
    // int totient = (((p-1)*(q-1)*(p-4)*(q-4))/4).floor();
    BigInt totient = (((p-BigInt.from(1))*(q-BigInt.from(1))*(p-BigInt.from(2).pow(r))*(q-BigInt.from(2).pow(r)))~/BigInt.from(2).pow(r));
    //BigInt totient = ((p-BigInt.from(1)) * (q-BigInt.from(1)));
    
    
    print("Totient = $totient");
    print("Test");
    //compute e, 1<e<O(n); such that gcd(e,O(n)) = 1
    // int e = genRandE(totient);
    BigInt e = genRandE(totient);


    //computing d, 1<d<O(n); such that e*d = 1 mod O(n) or d = multiplicativeinverse(e,phin)
    // int d = exteuclid(e, totient);
    BigInt d = exteuclid(e, totient);


    if(d<BigInt.from(0)){
      d += totient;
    }

    //Public key = (e,n)
    //Private key = (d,m)

    // calculating the hash of message using sha224
    var bytes = utf8.encode(msg);
    Digest signature = sha224.convert(bytes);
    print("Signature digest: $signature");
    BigInt M = BigInt.parse(signature.toString(),radix: 16);
    //BigInt encsignature = M.modPow(BigInt.from(d), BigInt.from(m));
    BigInt encsignature = M.modPow(d, m);
    print("M = $M");
    print("Message = ${msg} \nEncrypted Signature = ${encsignature}");
    print("Public keys:\n e = $e\n n =$n\n m =$m");
    print("Private keys:\n d = $d \n m = $m");
    print("Signature and message saved");

    //BigInt o = encsignature.modPow(BigInt.from(e), BigInt.from(m));
    BigInt o = encsignature.modPow(e, m);
    print("Decrypted signature: $o");

    //calculating hash of message
    var bytes2 = utf8.encode(msg);
    Digest signature2 = sha224.convert(bytes2);
    BigInt M2 = BigInt.parse(signature2.toString(), radix: 16);
    M2 = M2 % m;
    print("Hash of message: $M2");

    if(M2 == o){
      print("Hash of message = Decrypted Signature");
      print("Sender Verified.");
    } else{
      print("Hash of message != Decrypted Signature");
      print("Message has been tampered.");
    }





  }






  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // var bytes = utf8.encode('Message');
      //
      //
      // Digest sha224Result = sha224.convert(bytes);
      //
      // print('SHA224: $sha224Result');
      // print("Final: ${BigInt.parse(sha224Result.toString(), radix: 16)} " );
      // int test = gcd(135135498491335, 123456789123456789);
      // print("GCD: $test");
      // BigInt prime = randomPrimeBigInt(128) ;
      //
      // print(prime);
      encrypt();

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
