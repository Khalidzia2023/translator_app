import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/text_widget.dart';

class SliderController extends GetxController {
  // Observable values for pitch and speech rate
  var _pitchSlider = 1.0.obs;
  var _speechSlider = 1.0.obs;

  double get pitchSlider => _pitchSlider.value;
  double get speechSlider => _speechSlider.value;

  void showSliderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SizedBox(
              height: 270,
              child: Column(
                children: [
                  regularText(title: 'Speed rate of your speech'),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Speech rate'),
                        trailing: Obx(() => Text(pitchSlider.toStringAsFixed(2))),
                      ),
                      Obx(() => Slider(
                        value: pitchSlider,
                        min: 0.5,
                        max: 2.0,
                        divisions: 20,
                        label: pitchSlider.toStringAsFixed(2),
                        activeColor: Colors.deepPurple,
                        onChanged: (value) {
                          _pitchSlider.value = value; // Update observable pitch value
                        },
                      )),
                    ],
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Pitch '),
                        trailing: Obx(() => Text(speechSlider.toStringAsFixed(2))),
                      ),
                      Obx(() => Slider(
                        value: speechSlider,
                        min: 0.5,
                        max: 2.0,
                        divisions: 20,
                        label: speechSlider.toStringAsFixed(2),
                        activeColor: Colors.deepPurple,
                        onChanged: (value) {
                          _speechSlider.value = value; // Update observable speech rate value
                        },
                      )),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pitchSlider.value = 1.0; // Reset pitch
                          _speechSlider.value = 1.0; // Reset speech rate
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: regularText(title: 'Reset', textSize: 14, textColor: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Close dialog on "Ok"
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: regularText(title: 'OK', textSize: 14, textColor: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}