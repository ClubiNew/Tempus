import 'package:flutter/material.dart';

enum PopupOptions { rename, delete }

class EditPopup extends StatefulWidget {
  final void Function() onDelete;
  final void Function(String text) onRename;

  const EditPopup({
    required this.onDelete,
    required this.onRename,
    Key? key,
  }) : super(key: key);

  @override
  State<EditPopup> createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupOptions>(
      onSelected: (value) {
        switch (value) {
          case PopupOptions.rename:
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Rename'),
                content: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  maxLength: 50,
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
                      widget.onRename(controller.text);
                    },
                  ),
                ],
              ),
            );
            break;
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
    );
  }
}
