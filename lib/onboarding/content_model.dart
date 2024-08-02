// content_model.dart
class OnboardingContent {
  String image;
  String titleKey;
  String descriptionKey;

  OnboardingContent({
    required this.image,
    required this.titleKey,
    required this.descriptionKey,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    titleKey: 'onb_tit_1',
    image: 'images/onb_1.png',
    descriptionKey: 'onb_des_1',
  ),
  OnboardingContent(
    titleKey: 'onb_tit_2',
    image: 'images/sample_3d.png',
    descriptionKey: 'onb_des_2',
  ),
  OnboardingContent(
    titleKey: 'onb_tit_3',
    image: 'images/onb_3.png',
    descriptionKey: 'onb_des_3',
  ),
];
