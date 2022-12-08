import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: 150,
      height: 300,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
          const SizedBox(height: 10,),
          OutlinedButton.icon(
            label: const Text('Add icon'),
            onPressed: () {},
            icon: const Icon(Icons.image),
          ),
          const SizedBox(height: 80,),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: const Text('Close'),
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
