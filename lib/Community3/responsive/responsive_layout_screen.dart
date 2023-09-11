import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/responsive/global_variables.dart';
import 'package:provider/provider.dart';


class ResponsiveLayout extends StatefulWidget {

  final Widget webscreenlayout;
  final Widget mobilescreenlayout;

  ResponsiveLayout({required this.mobilescreenlayout,required this.webscreenlayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();

  }

  addData() async{
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth > webscreensize ){
          return widget.webscreenlayout;
        }

        // mobile screen
        return widget.mobilescreenlayout;
      },
    );
  }
}