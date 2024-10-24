import 'package:flutter/material.dart';
import 'package:medias_manager/widgets/dropdown_items_widget.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';

// class AudioScreen extends StatelessWidget {
//   const AudioScreen({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     final List<String> formatList = ['mp3', "wav", "wma", "au", "m4a", "aac"];
//     // double width = MediaQuery.of(context).size.width - 16.0;
//     return Scaffold(
//       appBar: AppBar(
//         title: Title(
//           color: Colors.cyan,
//           child: const Text("Audio"),
//         ),
//       ),
//       // body: const FilesListWidget(mediaCategory: "Audio",),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: DropdownItems(
//               itemsList: formatList,
//               initialItem: null,
//               callback: callback,
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               //  Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const FilesListWidget(
//                     mediaCategory: "Audio",
//                   ),
//                 ),
//               );
//             },
//             child: const Text("Liste des fichiers"),
//           ),
//         ],
//       ),
//     );
//   }
//   callback(selectedItem) {
//     debugPrint('selectedIem $selectedItem');
//     }
  
// }
