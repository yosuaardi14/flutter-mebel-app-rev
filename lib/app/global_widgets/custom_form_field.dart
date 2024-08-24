import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key, required this.child, this.required = false});
  final FormBuilderFieldDecoration child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Row(
      //     children: [
      //       Text(
      //         child.decoration.hintText.toString(),
      //         style: const TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       if(required)
      //         const Text(" *", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
      //     ],
      //   ),
      title: Text.rich(
        TextSpan(
          text: child.decoration.hintText,
          children: [
            if (required)
              const TextSpan(
                  text: " *",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
          ],
        ),
      ),
      subtitle: child,
      contentPadding: EdgeInsets.zero,
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Row(
    //       children: [
    //         Text(
    //           child.decoration.hintText.toString(),
    //           style: const TextStyle(fontWeight: FontWeight.bold),
    //         ),
    //         if(required)
    //           const Text(" *", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
    //       ],
    //     ),
    //     child,
    //     const SizedBox(height: 10),
    //   ],
    // );
  }
}
