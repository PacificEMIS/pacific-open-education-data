import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:pacific_dashboards/pages/home/inner_page/onboarding_view_model.dart';
import 'package:pacific_dashboards/res/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/emis.dart';
import '../../../view_model_factory.dart';
import '../inner_page/components/country_dialog.dart';
import 'onboarding_item.dart';

class OnboardingPage extends MvvmStatefulWidget {
  static const String kRoute = "/Onboarding";

  @override
  _OnboardingPageState createState() => _OnboardingPageState();

  OnboardingPage({Key key})
      : super(
          key: key,
          viewModelBuilder: (ctx) =>
              ViewModelFactory.instance.createonboardingViewModel(ctx),
        );
}

class _OnboardingPageState
    extends MvvmState<OnboardingViewModel, OnboardingPage> {
  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF1A73E8),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              PageView.builder(
                itemCount: OnboardingItem.values.length,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  if (index == 3) {
                    return _FinalPageItem(
                      item: OnboardingItem.values[index],
                      viewModel: viewModel,
                    );
                  }
                  return _DefaultPageItem(
                    item: OnboardingItem.values[index],
                  );
                },
              ),
              Positioned(
                bottom: 14,
                child: Row(
                  children: indicators(context),
                ),
              ),
            ],
          ),
        ),
      );

  List<Widget> indicators(BuildContext context) {
    final list = <Widget>[];
    for (var i = 0; i < OnboardingItem.values.length; i++) {
      list.add(
        i == _currentPage
            ? const _PageIndicator(isSelected: true)
            : const _PageIndicator(isSelected: false),
      );
    }
    return list;
  }
}

class _DefaultPageItem extends StatelessWidget {
  final String launchUrl =
      'https://docs.pacific-emis.org/doku.php?id=poed_user_manual';

  const _DefaultPageItem({
    this.item,
    Key key,
  }) : super(key: key);

  final OnboardingItem item;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Center(
              child: SizedBox(
                width: 300,
                height: 280,
                child: Image.asset(item.imagePath),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      );
}

class _FinalPageItem extends StatefulWidget {
  const _FinalPageItem({
    this.item,
    this.viewModel,
    Key key,
  }) : super(key: key);

  final OnboardingItem item;
  final OnboardingViewModel viewModel;

  @override
  State<_FinalPageItem> createState() => _FinalPageItemState();
}

class _FinalPageItemState extends State<_FinalPageItem> {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 64),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          widget.item.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 250,
            height: 170,
            child: Image.asset(widget.item.imagePath),
          ),
        ),
        const SizedBox(height: 8),
        LinkText(
            text: widget.item.text,
            textStyle: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white, fontSize: 16),
            linkStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                color: AppColors.kYellow,
                fontSize: 16,
                decoration: TextDecoration.underline),
            onLinkTap: (launchUrl) async {
              // if (await canLaunch(
              //     'https://docs.pacific-emis.org/doku.php?id=poed_user_manual')) {
              await launch(
                'https://docs.pacific-emis.org/doku.php?id=poed_user_manual',
              );
              // } else {
              //   throw 'Could not launch $launchUrl';
              // }
            }),
        const SizedBox(height: 24),
        StreamBuilder<Emis>(
            stream: widget.viewModel.selectedEmisStream,
            builder: (context, snapshot) {
              return _ChooseCountryButton(
                emis: snapshot.data,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CountrySelectDialog(
                        viewModel: widget.viewModel,
                      );
                    },
                  );
                },
              );
            }),
        const SizedBox(height: 16),
        StreamBuilder<Emis>(
            stream: widget.viewModel.selectedEmisStream,
            builder: (context, snapshot) {
              return ElevatedButton(
                  onPressed: () {
                    snapshot.data == null
                        ? null
                        : widget.viewModel.onContinuePressed(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        snapshot.data == null ? Colors.white70 : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: Text(
                    'Continue'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF63696D),
                    ),
                  ));
            }),
        const SizedBox(height: 24),
        _CheckboxTile(
          value: widget.viewModel.skipWelcomePage,
          onChanged: (value) {
            setState(() {
              widget.viewModel.onSkipWelcomePageChanged(value);
            });
          },
        ),
      ]));
}

class _ChooseCountryButton extends StatelessWidget {
  const _ChooseCountryButton({
    this.emis,
    this.onTap,
    Key key,
  }) : super(key: key);

  final Emis emis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDBE0E4)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, top: 0, bottom: 0, right: 0),
                    child: Text(
                      (emis == null) ? 'Choose country' : emis.getName(context),
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: (emis == null) ? Colors.black12 : Colors.black,
                          height: 1.1),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: (emis == null) ? Colors.black12 : Colors.black,
                  size: 21.0,
                ),
              ])));
}

class _CheckboxTile extends StatelessWidget {
  const _CheckboxTile({
    this.value,
    this.onChanged,
    Key key,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: InkWell(
          onTap: () {
            onChanged?.call(!value);
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                visualDensity: VisualDensity.compact,
                checkColor: const Color(0xFF1A73E8),
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.all(Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Skip this welcome page on future access',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    this.isSelected,
    Key key,
  }) : super(key: key);

  final bool isSelected;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: isSelected ? 20 : 8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
