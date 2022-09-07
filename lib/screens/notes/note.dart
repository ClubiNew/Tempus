import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';
import 'package:tempus/shared/cards.dart';
import 'package:tempus/shared/edit_popup.dart';

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
  final TextEditingController controller = TextEditingController();
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
        widget.entry.content = controller.text;
        widget.onChange();
        saved = true;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (saved) {
      controller.text = widget.entry.content;
    }

    return TitledCard(
      title: widget.entry.title ?? "Untitled entry",
      actions: [
        ReorderableDragStartListener(
          index: widget.index,
          child: const Icon(Icons.drag_handle),
        ),
        EditPopup(
          onDelete: widget.onDelete,
          onRename: (String text) {
            widget.entry.title = text;
            widget.onChange();
          },
        ),
      ],
      child: TextField(
        controller: controller,
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
