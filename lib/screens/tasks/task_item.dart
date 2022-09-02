import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempus/services/firestore/models.dart';

final RegExp exitCharacters = RegExp("[\r\n]");

class TaskItem extends StatefulWidget {
  const TaskItem({
    required this.task,
    required this.showDeleteButton,
    required this.onUpdate,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  final Task task;
  final bool showDeleteButton;

  final void Function() onUpdate;
  final void Function() onDelete;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.detail);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.task.detail = _controller.text.length > 512
            ? _controller.text.substring(0, 512)
            : _controller.text;
        _controller.text = widget.task.detail;
        widget.onUpdate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color oddItemColor = primaryColor.withOpacity(0.05);
    final Color evenItemColor = primaryColor.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: widget.task.order.isOdd ? oddItemColor : evenItemColor,
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
                  value: widget.task.completed,
                  onChanged: (value) {
                    widget.task.completed = value == true;
                    widget.onUpdate();
                  },
                ),
                Flexible(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      if (text.contains(exitCharacters)) {
                        _controller.text = text.replaceAll(exitCharacters, "");
                        _focusNode.unfocus();
                      }
                    },
                    onEditingComplete: () {
                      _focusNode.unfocus();
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
                    index: widget.task.order,
                    child: const Icon(Icons.drag_handle),
                  ),
          ),
        ],
      ),
    );
  }
}
