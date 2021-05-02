import 'package:flutter/material.dart';
import 'package:flutter_sqlite/widget/color_code_converter.dart';

class NoteFormWidget extends StatelessWidget {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    this.onChangedImportant,
    this.onChangedNumber,
    this.onChangedTitle,
    this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Tooltip(
                    message: 'Mark as important',
                    child: Switch(
                      value: isImportant ?? false,
                      onChanged: onChangedImportant,
                      activeColor: HexColor('22223b'),
                    ),
                  ),
                  Expanded(
                    child: Tooltip(
                      message: 'Important value',
                      child: Slider(
                        value: (number ?? 0).toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (number) => onChangedNumber(number.toInt()),
                        activeColor: HexColor('22223b'),
                      ),
                    ),
                  )
                ],
              ),
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: HexColor('f2e9e4'),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: HexColor('f2e9e4')),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 22,
        initialValue: description,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}
