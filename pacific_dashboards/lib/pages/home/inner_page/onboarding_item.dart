import 'package:flutter/material.dart';

class OnboardingItem {
  OnboardingItem({
    this.title, this.text, this.imagePath,
    // required this.title,
    // required this.text,
    // required this.imagePath,
  });

  final String title;
  final String text;
  final String imagePath;

  static List<OnboardingItem> values = [
    OnboardingItem(
      title: 'Welcome to the Pacific Open Education Data app',
      text:
          'We designed this app in our on-going efforts to more widely disseminate our data into the hands of users including data analylists, department leaders, operational staff, academic researchers, consultants and others. It publishes a selection of statistics from as far back as we have data. The quality of data is significantly improved in more recent years.',
      imagePath: 'images/logo.png',
    ),
    OnboardingItem(
      title: 'Use the app from your mobile device',
      text:
          'Unlike a web application available to those with Internet and not optimized for mobiles, our app works on phones with or without the Internet. Phones are the most widely available devices in the Pacific Islands. To use the app offline you will need to be somewhere with the Internet to both Install the app and download the data.',
      imagePath: 'images/onboarding_phone.png',
    ),
    OnboardingItem(
      title: 'Watch your internet connection',
      text:
          'Finally, due to the nature of this app which does require a good Internet connection to get started, bare in mind that you may encounter errors on bad Internet connections, especially when first installing and trying it out. This should be transient and the return of the good Internet should get things working.',
      imagePath: 'images/onboarding_earth.png',
    ),
    OnboardingItem(
      title: 'Choose country',
      text:
          'Participating Pacific Islands countries are included below. You can select one to access the data and/or you can also directly download data for any country for offline usage.',
      imagePath: 'images/onboarding_flags.png',
    ),
  ];
}
