import 'package:flutter/material.dart';
import 'package:stronglier/common/global_variables.dart';

class AddFloatingButton extends StatelessWidget {
  const AddFloatingButton({
    super.key,
    required this.onPressed,
  });
  
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55, right: 15),
      child: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: 'Add',
          backgroundColor: GV.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
