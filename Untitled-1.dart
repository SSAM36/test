import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:node_editor/node_editor.dart';
import 'package:skn_editor/AddButton.dart';
import 'package:skn_editor/SyntaxNode.dart';
import 'package:skn_editor/NodeContainer.dart';
import 'package:skn_editor/TopRowCategoryContainer.dart';
import 'package:skn_editor/TopRowElement.dart';

void main() {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    BrowserContextMenu.disableContextMenu().then((value) {
      debugPrint('Context Menu for web disabled');
    });
  }
  runApp(AppSkeleton());
}
class AppSkeleton extends StatefulWidget {
  @override
  _AppSkeletonState createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> {
  final NodeEditorController _controller = NodeEditorController();
  final FocusNode _focusNode = FocusNode();

  // Dynamic list of categories
  late List<List<TopRowElement>> categories;

  @override
  void initState() {
    super.initState();

    // Initialize categories with the default "Main" category
    categories = [
      [
        TopRowElement('New', () {
          _controller.addNode(SyntaxNode(width: 150, name: 'aaa', typeName: 'aaa'),
              const NodePosition.custom(Offset(3000, 3000)));
        } , isEditable: false,),
        TopRowElement('Open', () {
          _controller.addNode(SyntaxNode(width: 150, name: 'aaa2', typeName: 'aaa2'),
              const NodePosition.custom(Offset(3000, 3000)));
        },  isEditable: false,),
        TopRowElement('Save', () {}, isEditable: false),
        TopRowElement('Save As', () {}, isEditable: false),
        TopRowElement('Customize KID(s)', () {}, isEditable: false),
        TopRowElement('Customize Delimiter(s)', () {}, isEditable: false)
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Scrollbar(
                interactive: true,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 12.5),
                  scrollDirection: Axis.horizontal,
                  primary: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Render the default "Main" category container
                      TopRowCategoryContainer(
                        'Main',
                        categories[0],
                        containerColor: Colors.grey[200],
                        textColor: Colors.black,
                        dividerColor: Colors.grey[400],
                          isEditable: false,
                      ),
                      // Render other dynamically added categories
                      ...categories.skip(1).map((elements) {
                        return TopRowCategoryContainer(
                          'Custom Category',
                          elements,
                          containerColor: Colors.blue[100],
                          textColor: Colors.blue[900],
                          dividerColor: Colors.blue[300],
                          isEditable: true,
                        );
                      }).toList(),
                      AddButton(onPressed: _addCategory)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(child: NodeContainer('Fixed Nodes')),
                          Expanded(child: NodeContainer('Normal Nodes')),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        clipBehavior: Clip.antiAlias,
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).dividerColor, width: 2.5),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: NodeEditor(
                          background: GridBackground(
                              backgroundColor:
                              Theme.of(context).colorScheme.surface,
                              lineColor: Theme.of(context).dividerColor),
                          focusNode: _focusNode,
                          controller: _controller,
                          infiniteCanvasSize: 6000,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// Add a new blank category
  void _addCategory() {
    setState(() {
      categories.add([
        TopRowElement('+', () => _addElementToCategory(categories.length - 1), isEditable: false),
      ]);
    });
  }

// Add a new element to a specific category
  void _addElementToCategory(int categoryIndex) {
    setState(() {
      // Insert the new element before the last item in the list (before the "+")
      categories[categoryIndex].insert(
        categories[categoryIndex].length - 1, // Position before the "+" button
        TopRowElement('New Element', () {
          debugPrint('New Element in Category $categoryIndex clicked');
        }),
      );
    });
  }

}
