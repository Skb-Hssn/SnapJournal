import 'package:flutter/material.dart';
import 'package:snapjournal/SnapJournal/constants/enums.dart';
import 'package:snapjournal/TagSearch/tagevents_view.dart';
import 'package:snapjournal/TagSearch/tagsearch_widget.dart';

import '../Database/database.dart';
import '../Model/tag_model.dart';


class TagSearch extends StatefulWidget {
  const TagSearch({Key? key}) : super(key: key);


  @override
  State<TagSearch> createState() => _TagSearchState();
}

class _TagSearchState extends State<TagSearch> {

  final TextEditingController _searchBarController = TextEditingController();
  List<Tag> selectedTags = [];
  List<Tag> filteredTags = [];
  List<Tag> allTags = [];

  Set<String> eventIDset = {};



  @override
  void initState() {
    super.initState();
    readTag();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search"),
        backgroundColor: Color(darkViolet),),
      body: _buildBody(),
    );

  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: TagSearchWidget(
          key: const ValueKey('key'),
          searchBarTitle: 'Search States',
          searchBarController: _searchBarController,
          onSearchTextChanged: onSearchTextChanged,
          onSelected: onSelected,
          selected: selectedTags,
          filtered: filteredTags,
          all: allTags,
          onConfirms: onConfirms,
      ),
    );
  }

  void onSearchTextChanged(String text) {
    filteredTags.clear();
    setState(() {
      if (text.isEmpty) {
        return;
      }
      for (Tag _tags in allTags) {
        if (_tags.tagName
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .toLowerCase()
            .contains(text)) filteredTags.add(_tags);
      }
    });
  }

  void onSelected(String eventID) {
    print('New tag has been selected.---------------------------------------- $eventID');
  }

  void onConfirms() {
    Set<String> uniqueTags = Set();
    Map<String, Set<String>> ids = {};

    for(var t in selectedTags) {
      uniqueTags.add(t.tagName);
    }

    int uniqueTagCnt = uniqueTags.length;

    for(var t in selectedTags) {
      if(ids[t.eventId] == null) ids[t.eventId!] = {};
      ids[t.eventId]!.add(t.tagName);
    }

    List<String> selectedIds = [];

    ids.forEach((key, value) {
      if(value.length == uniqueTagCnt) {
        selectedIds.add(key);
      }
    });

    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>  TaggedEventView(eventIDs: selectedIds,),
      ),
    );
  }
  
  
  Future readTag() async{

    List<Tag> t = await DB.instance.retrieveTag();
    //
    int len = t.length;

    //
    // Tag tt = Tag.allFields(eventId: "1", tagName: "tag1");
    // Tag tt1 = Tag.allFields(eventId: "2", tagName: "tag2");
    // Tag tt2 = Tag.allFields(eventId: "3", tagName: "tag3");
    //  Tag tt3 = Tag.allFields(eventId: "4", tagName: "tag4");
    //



    if(mounted) {
      setState(() {

        for(int i = 0; i < len; i++) {
          // allTags.add(tt);
          // allTags.add(tt1);
          // allTags.add(tt2);
          // allTags.add(tt3);
          allTags.add(Tag.allFields(eventId: t[i].eventId, tagName: t[i].tagName));
          
        }

      });
    }

  }
}
