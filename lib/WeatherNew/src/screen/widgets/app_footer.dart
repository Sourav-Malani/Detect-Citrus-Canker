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
          Text("Weather Information",
              style: Theme.of(context).textTheme.overline),
          Text(
            "FYP",
            style: Theme.of(context).textTheme.overline,
          ),
          Text(
            "© CankerDetect 2023",
            style: Theme.of(context).textTheme.overline,
          ),
          // Text()
        ],
      ),
    );
  }
}
