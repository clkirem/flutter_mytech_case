import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';

class SourceTileWidget extends StatelessWidget {
  const SourceTileWidget({
    super.key,
    required this.sourceId,
    required this.title,
    required this.imageUrl,
    required this.isFollowed,
    required this.hintTextColor,
    required this.primaryColor,
    required this.onToggle,
  });

  final String sourceId;
  final String title;
  final String imageUrl;
  final bool isFollowed;
  final Color hintTextColor;
  final Color primaryColor;
  final Function(String, bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(imageUrl)),
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: CupertinoSwitch(
        value: isFollowed,
        onChanged: (bool newValue) {
          onToggle(sourceId, newValue);
        },
        activeColor: primaryColor,
        inactiveThumbColor: hintTextColor,
        inactiveTrackColor: inputFillColor,
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}
