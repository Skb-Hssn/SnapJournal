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
  List<Tag> selectedTags = [];
  List<Tag> filteredTags = [];

  //fetch all the tags
   List<Tag> allTags = [];


  @override
  Widget build(BuildContext context) {
    return Container();
  }



  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: SearchView(
          key: const ValueKey('key'),
          searchBarTitle: 'Search Tags',
          searchBarController: _searchBarController,
          onSearchTextChanged: onSearchTextChanged,
          onSelected: onSelected,
          selected: selectedTags,
          filtered: filteredTags,
          all: allStates,
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredTags.clear();
    setState(() {
      if (text.isEmpty) {
        return;
      }
      for (Tag _state in []) {
        if (_state.tagName
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .toLowerCase()
            .contains(text)) filteredTags.add(_state);
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
