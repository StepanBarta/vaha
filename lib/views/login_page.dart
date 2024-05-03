

import 'package:flutter/material.dart';
import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/inc/funkce.inc.dart';
import 'package:gaubeVaha/build/login.build.dart';
import 'package:gaubeVaha/build/verify.build.dart';
import 'package:gaubeVaha/views/home_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Auth {

  // of the TextField.
  final userName = TextEditingController();
  final userPass = TextEditingController();
  final serverName = TextEditingController();


  bool isLoading = false;

  @override
  void initState() {
    print("log screen"); 
    _prefillLoginForm();
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    userPass.dispose();
    serverName.dispose();
    super.dispose();
  }


  void _prefillLoginForm() async {
    userName.text = await getUserName();
    userPass.text = await getUserPass();
    serverName.text = await getServerName();
  }


  void _submitLogin() async {
    _setIsLoading(true);

    if (serverName.text.isNotEmpty) {
      LoginBuild log = LoginBuild(
        userName.text,
        userPass.text,
        serverName.text,
      );
      bool isLogged = await log.loginSubmit();

      if (isLogged) {
        await _verifyUser();
        _redirectToMainPage();
      }
    } else {
      notificationAlert(message: 'Zadejte server');
    }

    _setIsLoading(false);
  }

  void _neco() {
    _verifyUser();
  }

  _verifyUser() async {
    VerifyUserBuild ver = VerifyUserBuild();
    await ver.verifyUser();
    if (mounted) setState(() {});
  }

  void _redirectToMainPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 150,
                  /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: Image.asset('asset/logo.jpg'),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      'Už. jméno', /* hintText: 'Enter valid email id as abc@gmail.com' */
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userPass,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Heslo', /* hintText: 'Enter secure password' */
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                controller: serverName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Server',
                ),
              ),
            ),
            /* TextButton(
              onPressed: () {
                //TODO: FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Zapomenuté heslo',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ), */
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () => _submitLogin(),
                child: isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Přihlásit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () => _neco(),
                child: isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Tiskk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}