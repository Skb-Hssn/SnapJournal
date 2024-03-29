import 'package:flutter/material.dart';

import '../Model/tag_model.dart';

class TagSearchWidget extends StatefulWidget {
  final TextEditingController searchBarController;
  final Function(String) onSearchTextChanged;
  final Function() onConfirms;
  final Function onSelected;
  final String searchBarTitle;
  final List<Tag> selected;
  final List<Tag> filtered;
  final List<Tag> all;

  const TagSearchWidget({
    required Key key,
    required this.searchBarTitle,
    required this.searchBarController,
    required this.onSearchTextChanged,
    required this.onSelected,
    required this.selected,
    required this.filtered,
    required this.all,
    required this.onConfirms,
  }) : super(key: key);

  @override
  _TagSearchWidgetState createState() => _TagSearchWidgetState();
}

class _TagSearchWidgetState extends State<TagSearchWidget> {
  bool isSearching() => widget.searchBarController.text.isNotEmpty;

  @override
  void initState() {
    widget.searchBarController
        .addListener(() => setState(() => widget.searchBarController.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        width: double.infinity,
        child: Column(
          children: [
            Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: _buildSearchBar()),
            if (isSearching())
              Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.8,
                    alignment: Alignment.topCenter,
                    child: _buildResultsList()),
              ),
          ],
        ));
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            cursorWidth: 2.0,
            cursorHeight: 22.0,
            cursorColor: Colors.black,
            controller: widget.searchBarController,
            keyboardType: TextInputType.text,
            onChanged: widget.onSearchTextChanged,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                hintText: widget.searchBarTitle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ))),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        //Tags will be built based on the items of selected list.
        if (widget.selected.isNotEmpty)
          SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: _buildFieldTags()),
        if (widget.searchBarController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () => widget.searchBarController.clear(),
                child: Icon(Icons.close, color: Colors.grey[500], size: 25)),
          ),
        IconButton(onPressed: () async {await widget.onConfirms();}, icon: Icon(Icons.search)),
      ],
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:
      widget.filtered.isEmpty ? widget.all.length : widget.filtered.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5))),
          child: ListTile(
            onTap: () async {
              //Widget automatically adds to selected list what you tap on.
              if (widget.filtered.isNotEmpty) {
                if (!widget.selected
                    .contains(widget.filtered.elementAt(index))) {
                  widget.selected.add(widget.filtered.elementAt(index));
                }
                await widget.onSelected(widget.filtered.elementAt(index).eventId);
              }

              setState(() => widget.searchBarController.clear());
            },
            title: Text(
                widget.filtered.isEmpty
                    ? widget.all.elementAt(index).tagName
                    : widget.filtered.elementAt(index).tagName,
                style: const TextStyle(fontSize: 15.0)),
          ),
        );
      },
    );
  }

  Widget _buildFieldTags() {
    const TextStyle textStyle = TextStyle(color: Colors.white);
    return ListView(scrollDirection: Axis.horizontal, children: [
      ...widget.selected.map((tag) {
        final Size size = (TextPainter(
            text: TextSpan(text: tag.tagName, style: textStyle),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
            .size;

        return Wrap(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: size.width + 55,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.greenAccent[400],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                    child: Text(tag.tagName,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true)),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child:
                    const Icon(Icons.close, size: 20, color: Colors.white),
                    onTap: () {
                      final foundItem = widget.selected
                          .where((element) => element.tagName == tag.tagName)
                          .first;
                      setState(() {
                        widget.selected.remove(foundItem);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ]);
      })
    ]);
  }
}