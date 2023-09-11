import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/screens/profileScreen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(labelText: "Search for user"),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('username',
                isGreaterThanOrEqualTo: searchController.text)
                .get(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(uid: snapshot.data!.docs[index]["uid"]))),
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]["photourl"])),
                        title: Text((snapshot.data!.docs[index]["username"])),
                      ),
                    );
                  });
            })
            : FutureBuilder(
            future: FirebaseFirestore.instance.collection("post").get(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Image.network(
                    snapshot.data!.docs[index]["postUrl"]
                ),
                staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              );
            }));
  }
}