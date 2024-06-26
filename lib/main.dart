import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _incrementCounter() {
    Navigator.pop(context);
    Navigator.of(context).push(
      BaseDialogRoute(const _Editor()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==================================================================

class BaseDialogRoute<T> extends ModalRoute<T> {
  BaseDialogRoute(this.child) : super();

  Widget child;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.95,
          maxWidth: screenSize.width * 0.9,
        ),
        width: screenSize.width * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    );
  }
}

class _Editor extends StatelessWidget {
  const _Editor();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close')),
          Expanded(
            child: ProImageEditor.asset(
              'assets/test.jpg',
              configs: ProImageEditorConfigs(
                // gets around the vibration package bug.  may not be needed later
                // to test check the all exceptions debug setting to see it happen
                helperLines: const HelperLines(
                  hitVibration: !kIsWeb,
                ),
                // this is a hack to fix the lines getting offset.  editor must be same size it seems
                // maybe fixed in the future
                imageEditorTheme: ImageEditorTheme(
                  subEditorPage: SubEditorPageTheme(
                    enforceSizeFromMainEditor: true,
                    positionTop: 0,
                    positionLeft: 0,
                    positionRight: 0,
                    positionBottom: 0,
                    barrierDismissible: true,
                    barrierColor: const Color(0x90272727),
                    borderRadius: BorderRadius.circular(10),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                ),
                blurEditorConfigs: const BlurEditorConfigs(maxBlur: 40),
                imageGenerationConfigs: const ImageGeneratioConfigs(
                  outputFormat: OutputFormat.png,
                  // captureOnlyBackgroundImageArea: true,
                  // pngLevel: 6,
                  // processorConfigs: ProcessorConfigs(maxConcurrency: 2),
                  generateImageInBackground: true,
                  // generateInsideSeparateThread: true,
                  maxOutputSize: Size(4096, 4096),
                ),
              ),
              callbacks: ProImageEditorCallbacks(
                onCloseEditor: () {
                  // _mode = _DrawPictureMode.view;

                  // setState(() {});
                },
                onImageEditingComplete: (bytes) {
                  // _imageBytes = bytes;
                  // setState(() {});

                  return Future.value();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
