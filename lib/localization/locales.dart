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
    'register': 'Register',
    'next': 'Next',
    'continue': 'Continue',
    'cancel': 'Cancel',
    'pls_ent_eml': 'Please enter the Email',
    'wait': 'Please wait. . . ',

    // Greetings
    'morning': 'Good Morning!',
    'afternoon': 'Good Afternoon!',
    'evening': 'Good Evening!',

    // Alerts
    'usr_n_avl': 'User isn\'t available',

    // Forgot Password page
    'fgt_ttl': 'Forgot Password',
    'fgt_des': 'Enter your email account to reset password',
    'fgt_pop_tit': 'Check Your Email!',
    'fgt_pop_des1': 'We’ve sent a password reset link to Inbox',
    'fgt_pop_btn1': 'Check Inbox',
    'fgt_pop_des2':
        'After resetting the password you can now login to Taskmate with your new password',

    // Dashboard
    'prf': 'Profile',
    'blnc': 'Balance',
    'trns': 'Trancaction History',
    'hlp': 'Help & Support',
    'invt': 'Invite Friends',
    'trms': 'Terms & Conditions',
    'about': 'About Us',
    'lg_out': 'Logout',

    // Profile
    'rws': 'Reviews',
    'edt_prf': 'Edit Profile',

    // Help and Support
    'hlp_ttl': 'Help & Support',
    'hlp_des':
        'For any kind of help and support please write us on the below mentioned mail ID. \nThank you!',

    // Invite Friends
    'ivt_ttl':'Invite Friends',
    'ivt_des':'Discover a world of opportunities for Sri Lankan freelancers with our app! Download now and embark on a journey of creativity, flexibility, and endless possibilities!',
    'ivt_btn1':'Scan QR Code',
    'ivt_btn2':'Share',

    // Buttons
    'bck': 'Back',

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
    'clnt_pstd_crd_des':
        'Publishing a job on our platform is not just a task, it\'s an opportunity to connect with the best freelancers in the industry. We\'ve made it easier and friendlier than ever.',
    'clnt_pstd_crd_btn': 'Post a Job',

    // ################### Freelancer section ##############################

    // Bottom Nav Bar

    // Messaging
    'message':'Messages',

    // Jobs page
    'projects': 'Projects',
    'tab_bar_1': 'Search',
    'tab_bar_2': 'Most Recent',
    'tab_bar_3': 'Urgent',
    'job_srch_des': 'Search by skills...',
    'job_srch_urg':
        'Jobs that need to be completed within 1 Day. Remember, Urgent means higher paying.',
    'job_srch_srch_des': 'Search for your Skill',
    'job_srch_srch_nothg': 'Nothing found!',

    // Profile
    'free_prof_hr': 'Hourly Rate',
    'free_prof_ovw': 'Overview',
    'free_prof_port': 'Portfolio',
    'free_prof_rvw': 'Reviews',
  };

  static const Map<String, dynamic> SI = {
    // Common
    'email': 'ඊමේල්',
    'password': 'මුරපදය',
    'conf_pw': 'මුරපදය තහවුරු කරන්න',
    'login': 'ඇතුල් වන්න',
    'forgot_pw': 'මුරපදය අමතක වුණා ද?',
    'register': 'ලියාපදිංචි කරන්න',
    'next': 'ඉදිරියට',
    'continue': 'දිගටම',
    'cancel': 'අවලංගු කරන්න',
    'pls_ent_eml': 'කරුණාකර විද්‍යුත් තැපෑල ඇතුලත් කරන්න',
    'wait': 'කරුණාකර රැඳී සිටින්න. . .',

    // Greetings
    'morning': 'සුභ උදෑසනක්!',
    'afternoon': 'සුභ සන්ධ්යාවක්!',
    'evening': 'සුභ සන්ධ්යාවක්!',

    // Alerts
    'usr_n_avl': 'පරිශීලක නොමැත',

    // Forgot Password page
    'fgt_ttl': 'මුරපදය අමතක විය',
    'fgt_des': 'මුරපදය නැවත සැකසීමට ඔබගේ විද්‍යුත් තැපැල් ගිණුම ඇතුලත් කරන්න',
    'fgt_pop_tit': 'ඔබගේ විද්‍යුත් තැපෑල පරීක්ෂා කරන්න!',
    'fgt_pop_des1': 'අපි මුරපද යළි පිහිටුවීමේ සබැඳියක් එන ලිපි වෙත යවා ඇත',
    'fgt_pop_btn1': 'එන ලිපි පරීක්ෂා කරන්න',
    'fgt_pop_des2':
        'මුරපදය නැවත සැකසීමෙන් පසු ඔබට දැන් ඔබගේ නව මුරපදය සමඟ Taskmate වෙත පිවිසිය හැක',

    // Dashboard
    'prf': 'පැතිකඩ',
    'blnc': 'ශේෂය',
    'trns': 'ගනුදෙනු ඉතිහාසය',
    'hlp': 'උදව් සහ සහාය',
    'invt': 'මිතුරන්ට ආරාධනා කරන්න',
    'trms': 'නියම සහ කොන්දේසි',
    'about': 'අපි ගැන',
    'lg_out': 'පිටවෙන්න',

    // Profile
    'rws': 'සමාලෝචන',
    'edt_prf': 'පැතිකඩ සංස්කරණය කරන්න',

    // Help and Support
    'hlp_ttl': 'උදව් සහ සහාය',
    'hlp_des':
        'ඕනෑම ආකාරයක උපකාරයක් සහ සහායක් සඳහා කරුණාකර පහත සඳහන් තැපැල් හැඳුනුම්පතෙහි අපට ලියන්න. \nඔබට ස්තුතියි!',

    // Invite Friends
    'ivt_ttl':'මිතුරන්ට ආරාධනා කරන්න',
    'ivt_des':'අපගේ යෙදුම සමඟ ශ්‍රී ලාංකික නිදහස් සේවකයින් සඳහා අවස්ථා ලෝකයක් සොයා ගන්න! දැන් බාගත කර නිර්මාණශීලීත්වය, නම්‍යශීලී බව සහ නිමක් නැති හැකියාවන් සහිත ගමනක් ආරම්භ කරන්න!',
    'ivt_btn1':'QR කේතය ස්කෑන් කරන්න',
    'ivt_btn2':'Share කරන්න',

    // Buttons
    'bck': 'ආපසු',

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
    'clnt_pstd_crd_des':
        'අපගේ වේදිකාවේ රැකියාවක් ප්‍රකාශයට පත් කිරීම කාර්යයක් පමණක් නොවේ, එය කර්මාන්තයේ හොඳම නිදහස් සේවකයින් සමඟ සම්බන්ධ වීමට අවස්ථාවකි. අපි එය වෙන කවරදාටත් වඩා පහසු සහ මිත්‍රශීලී කර ඇත.',
    'clnt_pstd_crd_btn': 'රැකියාවක් පළ කරන්න',

    // ################### Freelancer section ##############################

    // Bottom Nav Bar

    // Messaging
    'message':'පණිවිඩ',

    // Jobs page
    'projects': 'ව්‍යාපෘති',
    'tab_bar_1': 'සොයන්න',
    'tab_bar_2': 'මෑතකාලීන',
    'tab_bar_3': 'හදිසි',
    'job_srch_des': 'කුසලතා අනුව සොයන්න...',
    'job_srch_urg':
        'දින 1ක් ඇතුළත නිම කළ යුතු රැකියා. මතක තබා ගන්න, හදිසි යනු ඉහළ ගෙවීමක්!',
    'job_srch_srch_des': 'ඔබේ කුසලතාව සොයන්න',
    'job_srch_srch_nothg': 'කිසිවක් හමු නොවීය!',

    // Profile
    'free_prof_hr': 'පැයකට ගාස්තුව',
    'free_prof_ovw': 'දළ විශ්ලේෂණය',
    'free_prof_port': 'කළඹ',
    'free_prof_rvw': 'සමාලෝචන',
  };
}
