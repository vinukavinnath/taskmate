import 'package:flutter_localization/flutter_localization.dart';

// locals.dart
const List<MapLocale> LOCALS = [
  MapLocale('en', LocalData.EN),
  MapLocale('si', LocalData.SI),
];

mixin LocalData {
  static const Map<String, dynamic> EN = {
    'onb_tit_1': 'Unlock Creativity at Your Fingertips',
    'onb_des_1': 'Find the perfect graphic designer to bring your vision to life.',
    'onb_tit_2': 'Your Talent, Your Terms',
    'onb_des_2': 'Discover opportunities that match your skills, bid on jobs, complete projects, and get paid securely. Showcase your creativity and grow your freelance career.',
    'onb_tit_3': 'Connecting Passion with Purpose',
    'onb_des_3': 'Join our thriving community of clients and freelancers. Collaborate on exciting projects, achieve your goals, and experience the synergy of creative minds working together.',
    'sgn_up_ttl':'Sign Up & Find Your\nNext Gig',
    'sgn_up_emlbtn':'Continue with Email',

  };

  static const Map<String, dynamic> SI = {
    'onb_tit_1': 'ඔබගේ අත්වැලියේ නිර්මාණශීලීතාව අගයන්න',
    'onb_des_1': 'ඔබේ දැක්ම සැබෑ කිරීමට සුදුසු ග්‍රාෆික් නිර්මාණ ශිල්පියෙකු සොයා ගන්න.',
    'onb_tit_2': 'ඔබේ දක්ෂතා, ඔබේ කොන්දේසි',
    'onb_des_2': 'ඔබේ දක්ෂතා වලට ගැලපෙන අවස්ථා සොයා ගන්න, කටයුතු සඳහා ඉදිරිපත් කරන්න, ව්‍යාපෘති නිමා කරන්න, සහ ආරක්ෂිතව ගෙවීම් කරන්න. ඔබේ නිර්මාණශීලීත්වය ප්‍රදර්ශනය කරන්න සහ ඔබේ නිදහස් රැකියා වෘත්තිය වර්ධනය කරන්න.',
    'onb_tit_3': 'අභිලාෂය සමඟ වාසනාව එක් කිරීම',
    'onb_des_3': 'අපගේ සඛ්‍යානභූත පාරිභෝගිකයන් සහ නිදහස් කාර්ය මණ්ඩලයේ සාමාජිකයන් කණ්ඩායමට සම්බන්ධ වන්න. ආකර්ෂණීය ව්‍යාපෘතිවල සමඟ සහයෝගීව කටයුතු කරන්න, ඔබේ ඉලක්ක සාක්ෂාත් කර ගැනීමට සහ නිර්මාණාත්මක මනෝවික්‍රම සහයෝගීව වැඩ කිරීමේ අත්දැකීම් විඳින්න.',
    'sgn_up_ttl': 'ලියාපදිංචි වී ඔබේ ඊළඟ ගිග් සොයා ගන්න',
    'sgn_up_emlbtn':'ඊමේල්',
  };
}

