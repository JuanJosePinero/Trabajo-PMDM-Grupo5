import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class MindFulnessScreen extends StatelessWidget {
  const MindFulnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;
    final cardHeight = (cardWidth * 0.8);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: ListView(
          children: [
            buildSwiper(cardWidth, cardHeight),
            buildSwiper(cardWidth, cardHeight),
            buildSwiper(cardWidth, cardHeight),
          ],
        ),
      ),
    );
  }

  Widget buildSwiper(double cardWidth, double cardHeight) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Swiper(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/screen_images/meditation.jpg'),
                  fit: BoxFit.scaleDown,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              // Puedes personalizar el contenido de cada tarjeta aquí
              // Por ejemplo, agregar texto o botones
              child: Center(
                child: Text(
                  'Tarjeta ${index + 1}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
        autoplay: true,
      ),
    );
  }
}
