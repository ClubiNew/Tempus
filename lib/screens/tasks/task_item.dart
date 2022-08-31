import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempus/services/firestore/models.dart';

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
    String originalText = widget.task.detail;
    _controller = TextEditingController(text: originalText);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _controller.text != originalText) {
        widget.task.detail = _controller.text;
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

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
                    maxLength: 255,
                    inputFormatters: [
                      FilteringTextInputFormatter(
                        RegExp("[\n\r]"),
                        allow: false,
                      )
                    ],
                    textInputAction: TextInputAction.done,
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
