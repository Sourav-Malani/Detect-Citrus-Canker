import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  // Timezone timezone = Timezone();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      // color: Colors.pink,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("Mobile Application Development 2 - Midterm Project ",
              style: Theme.of(context).textTheme.overline),
          Text(
            "Martin Erickson Lapetaje | BSCS - 3",
            style: Theme.of(context).textTheme.overline,
          ),
          Text(
            "© Panahon 2022",
            style: Theme.of(context).textTheme.overline,
          ),
          // Text()
        ],
      ),
    );
  }
}
