import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempus/models/settings.dart';
import 'package:tempus/services/settings.dart';
import 'package:tempus/shared/cards.dart';

class NoteCard extends StatefulWidget {
  final FocusNode focusNode;

  const NoteCard({
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final TextEditingController controller = TextEditingController();
  bool saved = true;

  final SettingsService settingsService = SettingsService();
  UserSettings settings = UserSettings();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(saveNote);
  }

  void saveNote() {
    saved = !widget.focusNode.hasFocus;
    if (saved) {
      settings.stickyNote = controller.text;
      settingsService.saveSettings(settings);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    widget.focusNode.removeListener(saveNote);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<UserSettings>(context);

    if (saved) {
      controller.text = settings.stickyNote;
    }

    return TitledCard(
      title: "Sticky note",
      child: TextField(
        controller: controller,
        focusNode: widget.focusNode,
        minLines: 5,
        maxLines: null,
        onEditingComplete: () {
          widget.focusNode.unfocus();
        },
        onSubmitted: (_) {
          widget.focusNode.unfocus();
        },
      ),
    );
  }
}
