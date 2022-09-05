import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/shared/cards.dart';

final RegExp exitCharacters = RegExp("[\r\n]");

enum PopupOptions { rename, delete }

class NotesEntry extends StatefulWidget {
  final OrderedPageEntry entry;
  final int index;

  final void Function(FocusNode focusNode) onFocus;
  final void Function() onChange;
  final void Function() onDelete;

  const NotesEntry({
    required this.entry,
    required this.index,
    required this.onFocus,
    required this.onChange,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<NotesEntry> createState() => _NotesEntryState();
}

class _NotesEntryState extends State<NotesEntry> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool saved = true;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        widget.onFocus(focusNode);
        saved = false;
      } else {
        widget.entry.content = contentController.text;
        widget.onChange();
        saved = true;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (saved) {
      contentController.text = widget.entry.content;
    }

    return TitledCard(
      title: widget.entry.title ?? "Untitled entry",
      actions: [
        ReorderableDragStartListener(
          index: widget.index,
          child: const Icon(Icons.drag_handle),
        ),
        PopupMenuButton<PopupOptions>(
          onSelected: (value) {
            switch (value) {
              case PopupOptions.delete:
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text(
                      "Are you sure you want to delete this entry?",
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onDelete();
                        },
                      ),
                    ],
                  ),
                );
                break;
              case PopupOptions.rename:
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Rename'),
                    content: TextField(
                      controller: titleController,
                      textInputAction: TextInputAction.done,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.entry.title = titleController.text;
                          widget.onChange();
                        },
                      ),
                    ],
                  ),
                );
                break;
            }
          },
          itemBuilder: (_) => <PopupMenuEntry<PopupOptions>>[
            PopupMenuItem<PopupOptions>(
              value: PopupOptions.rename,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.edit),
                  SizedBox(width: 8.0),
                  Text("Rename"),
                ],
              ),
            ),
            PopupMenuItem<PopupOptions>(
              value: PopupOptions.delete,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.delete),
                  SizedBox(width: 8.0),
                  Text("Delete"),
                ],
              ),
            ),
          ],
        )
      ],
      child: TextField(
        controller: contentController,
        focusNode: focusNode,
        maxLines: null,
        onEditingComplete: () {
          focusNode.unfocus();
        },
        onSubmitted: (_) {
          focusNode.unfocus();
        },
      ),
    );
  }
}
