import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';




// BF% = 1.20 × BMI + 0.23 × Age - 10.8 × Sex - 5.4
// ths is body fat percent according to age and sex (1 for male and 0 for women)
// todo: consider this formula for next version





class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double age = 1;
  double weight = 80;
  double height = 1.70;

  @override
  Widget build(BuildContext context) {
    double calculatedBMI = (weight / (height * height));
    final double displayWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
      bottom: true,
      top: true,
      left: true,
      right: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "محاسبه BMI",
            textDirection: TextDirection.rtl,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BMIGauge(bmi: calculatedBMI),

              Text(calculatedBMI.toStringAsFixed(0)),

              // weight
              Card(
                surfaceTintColor: getColor(calculatedBMI),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "وزن: ${weight.toStringAsFixed(0)}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                              onPressed: () {
                                setState(() {
                                  weight = weight - 1;
                                });
                              },
                              icon: Icon(Icons.exposure_minus_1_rounded)),
                          SizedBox(
                            width: displayWidth * 0.7,
                            child: Slider(
                              value: weight,
                              min: 40,
                              max: 200,
                              divisions: 100,
                              label: weight.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  weight = value;
                                });
                              },
                            ),
                          ),
                          IconButton.filledTonal(
                              onPressed: () {
                                setState(() {
                                  weight = weight + 1;
                                });
                              },
                              icon: Icon(Icons.plus_one_rounded))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // height
              Card(
                surfaceTintColor: getColor(calculatedBMI),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "قد: ${height.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                              onPressed: () {
                                setState(() {
                                  height = height - 0.01;
                                });
                              },
                              icon: Icon(Icons.exposure_minus_1_rounded)),
                          SizedBox(
                            width: displayWidth * 0.7,
                            child: Slider(
                              value: height,
                              min: 0.5,
                              max: 3,
                              // divisions: 100,
                              label: height.toStringAsFixed(2),
                              onChanged: (double value) {
                                setState(() {
                                  height = value;
                                });
                              },
                            ),
                          ),
                          IconButton.filledTonal(
                              onPressed: () {
                                setState(() {
                                  height = height + 0.01;
                                });
                              },
                              icon: Icon(Icons.plus_one_rounded))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BMIGauge extends StatelessWidget {
  const BMIGauge({super.key, required this.bmi});

  final double bmi;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      // title: GaugeTitle(
      //   text: "BMI",
      //   textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      // ),
      axes: [
        RadialAxis(
          showAxisLine: true,
          minimum: 15,
          maximum: 41,
          ranges: [
            GaugeRange(
              startValue: 15,
              endValue: 18.4,
              color: Colors.blue,
            ),
            GaugeRange(
              startValue: 18.5,
              endValue: 24.9,
              color: Colors.green,
            ),
            GaugeRange(
                startValue: 25, endValue: 29.9, color: Colors.orangeAccent),
            GaugeRange(startValue: 30, endValue: 34.9, color: Colors.redAccent),
            GaugeRange(
              startValue: 35,
              endValue: 40,
              color: Colors.red[900],
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: bmi, needleColor: getColor(bmi)),
            myMarketPointer(16.75, "لاغر مفرط"),
            myMarketPointer(21.75, "متناسب"),
            myMarketPointer(27.5, "اضافه وزن"),
            myMarketPointer(32.5, "چاق"),
            myMarketPointer(37.5, "چاقی مفرط"),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                bmi.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: getColor(bmi)),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
        )
      ],
    );
  }
}

Color? getColor(double bmi) {
  return (bmi < 15)
      ? Colors.black
      : (bmi >= 15 && bmi <= 18.4)
          ? Colors.blue
          : (bmi >= 18.5 && bmi <= 24.9)
              ? Colors.green
              : (bmi >= 25 && bmi <= 29.9)
                  ? Colors.orangeAccent
                  : (bmi >= 30 && bmi <= 34.9)
                      ? Colors.redAccent
                      : (bmi >= 35 && bmi <= 40)
                          ? Colors.red[900]
                          : Colors.black;
}

GaugePointer myMarketPointer(double value, String title) {
  return MarkerPointer(
    markerType: MarkerType.text,
    text: title,
    value: value,
    textStyle: GaugeTextStyle(
      fontWeight: FontWeight.bold,
      // fontSize: isCardView ? 14 : 18,
      fontFamily: 'Times',
    ),
    offsetUnit: GaugeSizeUnit.factor,
    markerOffset: -0.13,
  );
}
