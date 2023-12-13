import 'dart:io';
import 'package:canker_detect/widget/recommed_initial.dart';
import 'package:canker_detect/widget/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'plant_photo_view.dart';

const _labelsFileName = 'assets/labels_two.txt';
const _modelFileName = 'model_unquant_one.tflite';

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser({Key? key}) : super(key: key);

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;
  String _recommendations = '';

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = '';
  double _accuracy = 0.0;

  late Classifier? _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
          'labels at $_labelsFileName, '
          'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the previous screen
        Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/icon/icon.png',height:20,width:20),
          backgroundColor: Colors.green,
          title: Text("Detect Canker"),
        ),
        body: SafeArea(
          child: Container(
            color: kBgColor,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(),
                SizedBox(height: 20),
                _buildPhotolView(),
                SizedBox(height: 10),
                _buildResultView(),
                Spacer(),
                _buildPickPhotoButton(
                  title: 'Take a photo',
                  source: ImageSource.camera,
                ),
                SizedBox(height: 10),
                _buildPickPhotoButton(
                  title: 'Pick from gallery',
                  source: ImageSource.gallery,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: PlantPhotoView(file: _selectedImageFile),
        ),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: kAnalyzingTextStyle);
  }

  Widget _buildTitle() {
    return const Text(
      'Citrus Canker Detection',
      style: kTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Adjust the radius as needed
        child: TextButton(
          onPressed: () => _onPickPhoto(source),
          style: TextButton.styleFrom(
            backgroundColor:Colors.green,
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: kButtonFont,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color:Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }



  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier!.predict(imageInput);

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    if (result == _ResultStatus.found) {
      if (plantLabel == 'CitrusHealthy') {
        _recommendations = 'Your citrus plant looks healthy!';
      } else if (plantLabel == 'CitrusInitial') {
        _recommendations =
        'It seems like your citrus plant has an initial stage of canker. '
            'Consider taking preventive measures.';
      } else if (plantLabel == 'CitrusFinal') {
        _recommendations =
        'Your citrus plant has a final stage of canker. '
            'Immediate action is required. Consult an expert.';
      } else {
        _recommendations = '';
      }
    } else {
      _recommendations = 'Fail to recognize the plant.';
    }

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  void _navigateToRecommendationsPage() {
    // Navigate to different recommendation pages based on the plant's state
    if (_resultStatus == _ResultStatus.found) {
      if (_plantLabel == 'CitrusInitial') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CitrusCankerRecommendationsPageInitial(),
          ),
        );
      } else if (_plantLabel == 'CitrusFinal') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CitrusCankerRecommendationsPageFinal(),
          ),
        );
      }
    }
  }
  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognize';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }

    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Probability: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        SizedBox(height: 20),
        if (_selectedImageFile != null &&
            (_resultStatus == _ResultStatus.found && title != 'Fail To Recognize' && title != 'CitrusHealthy'))
          GestureDetector(
            onTap: _navigateToRecommendationsPage,
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.7),
                  width: 2,
                ),
              ),
              child: Center(child: Text('Treatment')),
            ),
          ),
      ],
    );
  }
}