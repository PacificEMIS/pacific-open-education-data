class OnboardingItem {
  OnboardingItem({
    this.title,
    this.text,
    this.imagePath,
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
          'We designed this app as part of our on-going efforts to more widely disseminate our data into the hands of interested users such as school teachers/principals, data analysts, government department leaders, operational staff, academic researchers, consultants and others. The quality of data is significantly improved in more recent years.',
      imagePath: 'images/logo.png',
    ),
    OnboardingItem(
      title: 'Use the app from your mobile device',
      text:
          'Unlike a web application available to those with Internet only and not optimized for mobile devices, our app works on phones with or without the Internet. Phones are the most widely available devices in the Pacific Islands. To use the app offline you will first need to be somewhere with the Internet for the installation of the app and to download the data.',
      imagePath: 'images/onboarding_phone.png',
    ),
    OnboardingItem(
      title: 'Watch your internet connection',
      text:
          'Finally, since this app does need the Internet to load data from our servers, it is possible to encounter errors on bad Internet connections. This should be transient and the return to a good Internet connection should get things working. If you are located in a location with unreliable Internet or no Internet at all it is recommended to download all the data needed when on a good Internet.',
      imagePath: 'images/onboarding_earth.png',
    ),
    OnboardingItem(
      title: 'Choose country',
      text:
          'Participating Pacific Islands countries are included below. You can select one to access the data and/or you can also directly download data for any country for offline usage. A user guide is available online at https://docs.pacific-emis.org/doku.php?id=poed_user_manual.',
      imagePath: 'images/onboarding_flags.png',
    ),
  ];
}
