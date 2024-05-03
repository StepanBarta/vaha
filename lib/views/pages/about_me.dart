import 'package:flutter/material.dart';
import 'package:gaubeVaha/store/store_global.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  Widget _buildAboutBody() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              const Text('verze: '),
              Text(Global.appVersion),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('O aplikaci'),
        ),
        body: _buildAboutBody());
  }
}
