import 'package:carousel_slider/carousel_slider.dart';
import 'package:flukefy/view/screens/introduction/widgets/intro_card.dart';
import 'package:flukefy/view/screens/login/sign_in_screen.dart';
import 'package:flukefy/view/widgets/buttons/black_button.dart';
import 'package:flutter/material.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int currentIndex = 0;
  CarouselSliderController controller = CarouselSliderController();
  List<Widget> sliders = const [
    IntroCard(
      image: 'assets/images/introduction/discover.png',
      title: 'Discover',
      desc: 'Explore world top brands\nand boutiques',
    ),
    IntroCard(
      image: 'assets/images/introduction/credit_card.png',
      title: 'Make the payment',
      desc: 'Choose the preferable\noption of payment',
    ),
    IntroCard(
      image: 'assets/images/introduction/enjoy.png',
      title: 'Enjoy your shopping',
      desc: 'Get high quality products\nfor best price',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
            child: CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: sliders,
            ),
          ),

          // Bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 20),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: sliders.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => controller.animateToPage(entry.key),
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(currentIndex == entry.key ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  BlackButton(
                    title: currentIndex == 2 ? 'Sign in' : 'Next',
                    onPressed: () {
                      if (currentIndex == 2) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
                      } else {
                        setState(() {
                          controller.nextPage();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
