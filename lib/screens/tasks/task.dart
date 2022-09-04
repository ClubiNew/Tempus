import 'package:flutter/material.dart';
import 'package:tempus/models/pages.dart';

final RegExp exitCharacters = RegExp("[\r\n]");

class Task extends StatefulWidget {
  final OrderedPageEntry entry;
  final bool showDeleteButton;
  final int index;

  final void Function() onUpdate;
  final void Function() onDelete;

  const Task({
    required this.entry,
    required this.index,
    required this.showDeleteButton,
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late final TextEditingController controller;
  final FocusNode focusNode = FocusNode();
  bool saved = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.entry.content);
    focusNode.addListener(() {
      saved = !focusNode.hasFocus;
      if (saved) {
        widget.entry.content = controller.text;
        widget.onUpdate();
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
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color oddItemColor = primaryColor.withOpacity(0.05);
    final Color evenItemColor = primaryColor.withOpacity(0.15);

    if (saved) {
      controller.text = widget.entry.content;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: widget.index.isOdd ? oddItemColor : evenItemColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return primaryColor.withOpacity(.32);
                    }
                    return primaryColor;
                  }),
                  value: !widget.entry.active,
                  onChanged: (value) {
                    widget.entry.active = value != true;
                    widget.onUpdate();
                  },
                ),
                Flexible(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      if (text.contains(exitCharacters)) {
                        controller.text = text.replaceAll(exitCharacters, "");
                        focusNode.unfocus();
                      }
                    },
                    onEditingComplete: () {
                      focusNode.unfocus();
                    },
                    onSubmitted: (_) {
                      focusNode.unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: widget.showDeleteButton
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onDelete,
                  )
                : ReorderableDragStartListener(
                    index: widget.index,
                    child: const Icon(Icons.drag_handle),
                  ),
          ),
        ],
      ),
    );
  }
}
