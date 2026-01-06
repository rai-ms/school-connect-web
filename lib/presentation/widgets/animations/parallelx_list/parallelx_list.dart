import 'package:flutter/material.dart';

import '../../../../core/base/logger/app_logger_impl.dart';

class ParallaxEffect extends StatefulWidget {
  const ParallaxEffect({super.key});

  @override
  State<ParallaxEffect> createState() => _ParallaxEffectState();
}

class _ParallaxEffectState extends State<ParallaxEffect> {
  PageController pageController = PageController(viewportFraction: 0.6);

  double pageOffSet = 0;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        pageOffSet = pageController.page!;
      });
      Log.d(pageOffSet.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
          controller: pageController,
          itemCount: 5,
          itemBuilder: (context, index) {
            Log.d("${-pageOffSet.abs() + index}");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        height: 300,
                        child: Image.network(
                          'https://media.istockphoto.com/id/1288385045/photo/snowcapped-k2-peak.jpg?s=2048x2048&w=is&k=20&c=w2Qcpt4yVuD8nfG5pkrxwo0t_aq-fHewpEQX4gRa870=',
                          fit: BoxFit.cover,
                          alignment: Alignment(-pageOffSet.abs() + index, 0),
                        ),
                      )),
                  const Positioned(
                      bottom: 20,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Mountain',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            );
          }),
    );
  }
}
