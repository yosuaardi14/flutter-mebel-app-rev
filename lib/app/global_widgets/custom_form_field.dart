import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({Key? key, required this.child, this.required = false}) : super(key: key);
  final FormBuilderFieldDecoration child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
          children: [
            Text(
              child.decoration.hintText.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if(required)
              const Text(" *", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
          ],
        ),
      subtitle: child,
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
