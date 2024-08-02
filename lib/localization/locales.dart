import 'package:flutter_localization/flutter_localization.dart';

// locals.dart
const List<MapLocale> LOCALS = [
  MapLocale('en', LocalData.EN),
  MapLocale('si', LocalData.SI),
];

mixin LocalData {
  static const Map<String, dynamic> EN = {
    // Common
    'email': 'Email',
    'password': 'Password',
    'conf_pw': 'Confirm password',
    'login': 'Log In',
    'forgot_pw': 'Forgot your Password',

    // Greetings
    'morning':'Good Morning!',
    'afternoon':'Good Afternoon!',
    'evening':'Good Evening!',

    // Alerts
    'usr_n_avl': 'User isn\'t available',

    // Dashboard
    'prf':'Profile',
    'blnc':'Balance',
    'trns':'Trancaction History',
    'hlp':'Help & Support',
    'invt':'Invite Friends',
    'trms':'Terms & Conditions',
    'about':'About Us',
    'lg_out':'Logout',

    // Profile
    'rws':'Reviews',
    'edt_prf':'Edit Profile',

    // Help and Support
    'hlp_ttl':'Help & Support',
    'hlp_des':'For any kind of help and support please write us on the below mentioned mail ID. \nThank you!',

    // Buttons
    'bck':'Back',


    // Page Specific
    'onb_tit_1': 'Unlock Creativity at Your Fingertips',
    'onb_des_1':
        'Find the perfect graphic designer to bring your vision to life.',
    'onb_tit_2': 'Your Talent, Your Terms',
    'onb_des_2':
        'Discover opportunities that match your skills, bid on jobs, complete projects, and get paid securely. Showcase your creativity and grow your freelance career.',
    'onb_tit_3': 'Connecting Passion with Purpose',
    'onb_des_3':
        'Join our thriving community of clients and freelancers. Collaborate on exciting projects, achieve your goals, and experience the synergy of creative minds working together.',
    'sgn_up_ttl': 'Sign Up & Find Your\nNext Gig',
    'sgn_up_emlbtn': 'Continue with Email',
    'sgn_up_dvd': 'Or continue with',
    'sgn_up_ftr': 'Already registered?',
    'crt_acc': 'Create My Account',
    'lgin_ttl': 'Welcome Back!',
    'clnt_pstd_ttl': 'Welcome Back!',
    'clnt_pstd_crd_ttl': 'Get your work Done!',
    'clnt_pstd_crd_des': 'Publishing a job on our platform is not just a task, it\'s an opportunity to connect with the best freelancers in the industry. We\'ve made it easier and friendlier than ever.',
    'clnt_pstd_crd_btn': 'Post a Job',
  };

  static const Map<String, dynamic> SI = {
    // Common
    'email': 'ඊමේල්',
    'password': 'මුරපදය',
    'conf_pw': 'මුරපදය තහවුරු කරන්න',
    'login': 'ඇතුල් වන්න',
    'forgot_pw': 'මුරපදය අමතක වුණා ද?',

    // Greetings
    'morning':'සුභ උදෑසනක්!',
    'afternoon':'සුභ සන්ධ්යාවක්!',
    'evening':'සුභ සන්ධ්යාවක්!',

    // Alerts
    'usr_n_avl': 'පරිශීලක නොමැත',

    // Dashboard
    'prf':'පැතිකඩ',
    'blnc':'ශේෂය',
    'trns':'ගනුදෙනු ඉතිහාසය',
    'hlp':'උදව් සහ සහාය',
    'invt':'මිතුරන්ට ආරාධනා කරන්න',
    'trms':'නියම සහ කොන්දේසි',
    'about':'අපි ගැන',
    'lg_out':'පිටවෙන්න',

    // Profile
    'rws':'සමාලෝචන',
    'edt_prf':'පැතිකඩ සංස්කරණය කරන්න',

    // Help and Support
    'hlp_ttl':'උදව් සහ සහාය',
    'hlp_des':'ඕනෑම ආකාරයක උපකාරයක් සහ සහායක් සඳහා කරුණාකර පහත සඳහන් තැපැල් හැඳුනුම්පතෙහි අපට ලියන්න. \nඔබට ස්තුතියි!',

    // Buttons
    'bck':'ආපසු',

    // Page Specific
    'onb_tit_1': 'ඔබගේ අත්වැලියේ නිර්මාණශීලීතාව අගයන්න',
    'onb_des_1':
        'ඔබේ දැක්ම සැබෑ කිරීමට සුදුසු ග්‍රාෆික් නිර්මාණ ශිල්පියෙකු සොයා ගන්න.',
    'onb_tit_2': 'ඔබේ දක්ෂතා, ඔබේ කොන්දේසි',
    'onb_des_2':
        'ඔබේ දක්ෂතා වලට ගැලපෙන අවස්ථා සොයා ගන්න, කටයුතු සඳහා ඉදිරිපත් කරන්න, ව්‍යාපෘති නිමා කරන්න, සහ ආරක්ෂිතව ගෙවීම් කරන්න. ඔබේ නිර්මාණශීලීත්වය ප්‍රදර්ශනය කරන්න සහ ඔබේ නිදහස් රැකියා වෘත්තිය වර්ධනය කරන්න.',
    'onb_tit_3': 'අභිලාෂය සමඟ වාසනාව එක් කිරීම',
    'onb_des_3':
        'අපගේ සඛ්‍යානභූත පාරිභෝගිකයන් සහ නිදහස් කාර්ය මණ්ඩලයේ සාමාජිකයන් කණ්ඩායමට සම්බන්ධ වන්න. ආකර්ෂණීය ව්‍යාපෘතිවල සමඟ සහයෝගීව කටයුතු කරන්න, ඔබේ ඉලක්ක සාක්ෂාත් කර ගැනීමට සහ නිර්මාණාත්මක මනෝවික්‍රම සහයෝගීව වැඩ කිරීමේ අත්දැකීම් විඳින්න.',
    'sgn_up_ttl': 'ලියාපදිංචි වී ඔබේ ඊළඟ ගිග් සොයා ගන්න',
    'sgn_up_emlbtn': 'ඊමේල් සමඟ ඉදිරියට',
    'sgn_up_dvd': 'නැතහොත්',
    'sgn_up_ftr': 'දැනටමත් ලියාපදිංචි වී තිබේද?',
    'crt_acc': 'මගේ ගිණුම සකස් කරන්න',
    'lgin_ttl': 'සාදරයෙන් පිළිගනිමු!',
    'clnt_pstd_ttl': 'ආයුබෝවන්!',
    'clnt_pstd_crd_ttl': 'ඔබගේ කාර්යය නිම කර ගන්න!',
    'clnt_pstd_crd_des':'අපගේ වේදිකාවේ රැකියාවක් ප්‍රකාශයට පත් කිරීම කාර්යයක් පමණක් නොවේ, එය කර්මාන්තයේ හොඳම නිදහස් සේවකයින් සමඟ සම්බන්ධ වීමට අවස්ථාවකි. අපි එය වෙන කවරදාටත් වඩා පහසු සහ මිත්‍රශීලී කර ඇත.',
    'clnt_pstd_crd_btn': 'රැකියාවක් පළ කරන්න',
  };
}
