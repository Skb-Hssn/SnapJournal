import 'package:flutter/material.dart';
import 'package:snapjournal/Model/tag_model.dart';
import 'package:snapjournal/TagSearch/tagsearch_view.dart';

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
  // List<Tag> allStates = Taglist()
  //     .getTaglist()
  //     .map((state) => Tag(tagName: state))
  //     .toList();


  @override
  Widget build(BuildContext context) {
    return Container();
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
          all: [],
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredStates.clear();
    setState(() {
      if (text.isEmpty) {
        return;
      }
      for (Tag _state in []) {
        if (_state.tagName
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .toLowerCase()
            .contains(text)) filteredStates.add(_state);
      }
    });
  }

  void onSelected() {
    print('New tag has been selected.');
  }


}
