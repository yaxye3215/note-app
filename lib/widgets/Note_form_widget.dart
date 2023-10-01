//ignore: file_names
import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool isImportant;
  final ValueChanged<bool> onChangedIsmportant;
  final int number;
  final ValueChanged<int> onChangeNumber;
  final String title;
  final ValueChanged<String> onChangeTitle;
  final String description;
  final ValueChanged<String> onChangeDescription;

  const NoteFormWidget(
      {Key? key,
      required this.isImportant,
      required this.onChangedIsmportant,
      required this.number,
      required this.onChangeNumber,
      required this.title,
      required this.onChangeTitle,
      required this.description,
      required this.onChangeDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Switch(value: isImportant, onChanged: onChangedIsmportant),
                Expanded(
                    child: Slider(
                        value: number.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 5,
                        onChanged: (value) => onChangeNumber(value.toInt())))
              ],
            ),
            buildTitleField(),
            const SizedBox(
              height: 8,
            ),
            buildDescriptionField()
          ],
        ),
      ),
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.white30),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.white30),
              borderRadius: BorderRadius.circular(20)),
          hintText: "Title",
          hintStyle: const TextStyle(color: Colors.white70)),
      validator: (title) {
        return title != null && title.isEmpty
            ? 'The title cannot be empty'
            : null;
      },
      onChanged: onChangeTitle,
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      maxLines: 10,
      initialValue: description,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 3, color: Colors.white30),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.white30),
              borderRadius: BorderRadius.circular(20)),
          hintText: "Type...",
          hintStyle: const TextStyle(color: Colors.white70)),
      validator: (description) {
        return description != null && description.isEmpty
            ? 'The description cannot be empty'
            : null;
      },
      onChanged: onChangeDescription,
    );
  }
}
