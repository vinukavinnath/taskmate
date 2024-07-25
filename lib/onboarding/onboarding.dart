import 'package:flutter/material.dart';
import 'package:taskmate/authentication/sign_up.dart';
import 'package:taskmate/components/dark_main_button.dart';
// import 'package:taskmate/components/light_main_button.dart';
import 'package:taskmate/constants.dart';
import 'package:taskmate/onboarding/content_model.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/noise_image.webp'),
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image(
                                image: AssetImage(contents[i].image),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            contents[i].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          contents[i].description,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });

                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: 10.0,
                      width: (index == currentIndex) ? 20 : 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: (index == currentIndex)
                            ? (kDeepBlueColor)
                            : (Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              DarkMainButton(
                screenWidth: screenWidth,
                process: () {
                  if (currentIndex == contents.length - 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  } else {
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.bounceIn);
                  }
                },
                title: (currentIndex == contents.length - 1)
                    ? 'Let\'s Register'
                    : 'Next',
              ),
              // LightMainButton(
              //   title: 'Skip',
              //   process: () {Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const SignUp(),
              //     ),
              //   );},
              //   screenWidth: screenWidth,
              // ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
