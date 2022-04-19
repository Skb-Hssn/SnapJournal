import 'package:flutter/material.dart';
import 'package:snapjournal/Model/tag_model.dart';
import 'package:snapjournal/TagSearch/tagsearch_view.dart';

import '../Database/database.dart';

class TagSearch extends StatefulWidget {
  const TagSearch({Key? key}) : super(key: key);

  @override
  State<TagSearch> createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {

  final TextEditingController _searchBarController = TextEditingController();
  List<Tag> selectedStates = [];
  List<Tag> filteredStates = [];

  //fetch all the tags
   List<Tag> allTags = [];
   //Taglist()
  //     .getTaglist()
  //     .map((state) => Tag(tagName: state))
  //     .toList();


  @override
  void initState() {
    readTag();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Search Tag")),
        body: _buildBody(),
    );
  }



  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: SearchView(
          key: const ValueKey('key'),
          searchBarTitle: 'Search States',
          searchBarController: _searchBarController,
          onSearchTextChanged: onSearchTextChanged,
          onSelected: onSelected,
          selected: selectedStates,
          filtered: filteredStates,
          all: allTags,
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredStates.clear();
    setState(() {
      if (text.isEmpty) {
        return;
      }
      for (Tag _tag in []) {
        if (_tag.tagName
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .toLowerCase()
            .contains(text)) filteredStates.add(_tag);
      }
    });
  }

  void onSelected() {
    print('New tag has been selected.');
  }

  Future readTag() async{

    List<Tag> t = await DB.instance.retrieveTag();

    int len = t.length;

    if(mounted) {
      setState(() {

        for(int i = 0; i < len; i++) {
          allTags.add(Tag.search(tagName: t[i].tagName));
        }

      });
    }

  }


}
