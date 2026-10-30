// Interface strings for the six supported languages.
// Order in every list: ar, en, fr, ur, id, tr.

const List<String> kLangs = ['ar', 'en', 'fr', 'ur', 'id', 'tr'];
const List<String> kLangNames = ['العربية', 'English', 'Français', 'اردو', 'Bahasa Indonesia', 'Türkçe'];

int _li = 0;
String get currentLang => kLangs[_li];
void setLang(String code) {
  final i = kLangs.indexOf(code);
  _li = i < 0 ? 0 : i;
}

bool get isRtlLang => currentLang == 'ar' || currentLang == 'ur';

String t(String key, [Map<String, Object>? args]) {
  final row = _s[key];
  var out = row == null ? key : row[_li];
  if (args != null) {
    args.forEach((k, v) => out = out.replaceAll('{$k}', '$v'));
  }
  return out;
}

List<String> tl(String key) => _lists[key]![_li];

const Map<String, List<String>> _s = {
  'appName': ['مأوى', "Ma'wa", "Ma'wa", 'مأویٰ', "Ma'wa", "Me'vâ"],
  'home': ['الرئيسية', 'Home', 'Accueil', 'ہوم', 'Beranda', 'Ana Sayfa'],
  'quran': ['القرآن', 'Quran', 'Coran', 'قرآن', 'Al-Quran', "Kur'an"],
  'adhkar': ['الأذكار', 'Adhkar', 'Adhkar', 'اذکار', 'Dzikir', 'Zikirler'],
  'tasbih': ['المسبحة', 'Tasbih', 'Tasbih', 'تسبیح', 'Tasbih', 'Tesbih'],
  'more': ['المزيد', 'More', 'Plus', 'مزید', 'Lainnya', 'Daha fazla'],
  'goodMorning': ['صباح الخير', 'Good morning', 'Bonjour', 'صبح بخیر', 'Selamat pagi', 'Günaydın'],
  'goodEvening': ['مساء الخير', 'Good evening', 'Bonsoir', 'شام بخیر', 'Selamat malam', 'İyi akşamlar'],
  'morningSub': ['ابدأ يومك بأذكار الصباح', 'Start your day with the morning adhkar', 'Commencez votre journée par les adhkar du matin', 'اپنے دن کا آغاز صبح کے اذکار سے کریں', 'Mulai harimu dengan dzikir pagi', 'Güne sabah zikirleriyle başla'],
  'eveningSub': ['اختم يومك بأذكار المساء', 'End your day with the evening adhkar', 'Terminez votre journée par les adhkar du soir', 'اپنے دن کا اختتام شام کے اذکار سے کریں', 'Tutup harimu dengan dzikir petang', 'Günü akşam zikirleriyle bitir'],
  'nextPrayer': ['الصلاة القادمة', 'Next prayer', 'Prochaine prière', 'اگلی نماز', 'Salat berikutnya', 'Sonraki namaz'],
  'at': ['عند {t}', 'at {t}', 'à {t}', '{t} بجے', 'pukul {t}', 'saat {t}'],
  'fajr': ['الفجر', 'Fajr', 'Fajr', 'فجر', 'Subuh', 'İmsak'],
  'sunrise': ['الشروق', 'Sunrise', 'Lever du soleil', 'طلوع آفتاب', 'Terbit', 'Güneş'],
  'dhuhr': ['الظهر', 'Dhuhr', 'Dhuhr', 'ظہر', 'Dzuhur', 'Öğle'],
  'asr': ['العصر', 'Asr', 'Asr', 'عصر', 'Ashar', 'İkindi'],
  'maghrib': ['المغرب', 'Maghrib', 'Maghrib', 'مغرب', 'Maghrib', 'Akşam'],
  'isha': ['العشاء', 'Isha', 'Isha', 'عشاء', 'Isya', 'Yatsı'],
  'prayerTimes': ['مواقيت الصلاة', 'Prayer times', 'Horaires de prière', 'اوقات نماز', 'Jadwal salat', 'Namaz vakitleri'],
  'myLocation': ['موقعي الحالي', 'My location', 'Ma position', 'میرا مقام', 'Lokasi saya', 'Konumum'],
  'useGps': ['تحديد موقعي تلقائياً', 'Detect my location', 'Détecter ma position', 'میرا مقام خودکار معلوم کریں', 'Deteksi lokasi saya', 'Konumumu bul'],
  'locating': ['جارٍ تحديد الموقع…', 'Finding your location…', 'Localisation…', 'مقام معلوم کیا جا رہا ہے…', 'Mencari lokasi…', 'Konum bulunuyor…'],
  'locationFailed': ['تعذّر تحديد الموقع. فعّل خدمة الموقع واسمح للتطبيق باستخدامها، أو اختر مدينتك من القائمة.', 'Could not get your location. Turn on location and allow the app to use it, or pick your city from the list.', "Position introuvable. Activez la localisation et autorisez l'application, ou choisissez votre ville.", 'مقام معلوم نہیں ہو سکا۔ لوکیشن آن کریں اور اجازت دیں، یا فہرست سے اپنا شہر منتخب کریں۔', 'Lokasi tidak ditemukan. Aktifkan lokasi dan izinkan aplikasi, atau pilih kota dari daftar.', 'Konum alınamadı. Konumu açıp uygulamaya izin verin veya listeden şehrinizi seçin.'],
  'chooseCity': ['اختر مدينة', 'Choose a city', 'Choisir une ville', 'شہر منتخب کریں', 'Pilih kota', 'Şehir seç'],
  'searchCity': ['ابحث عن مدينة', 'Search for a city', 'Rechercher une ville', 'شہر تلاش کریں', 'Cari kota', 'Şehir ara'],
  'method': ['طريقة الحساب', 'Calculation method', 'Méthode de calcul', 'حساب کا طریقہ', 'Metode perhitungan', 'Hesaplama yöntemi'],
  'asrMethod': ['حساب العصر', 'Asr calculation', "Calcul de l'Asr", 'عصر کا حساب', 'Perhitungan Ashar', 'İkindi hesabı'],
  'asrStd': ['الجمهور (المثل)', 'Standard (Shafi‘i, Maliki, Hanbali)', 'Standard (chaféite, malikite, hanbalite)', 'جمہور (شافعی، مالکی، حنبلی)', 'Standar (Syafi‘i, Maliki, Hanbali)', 'Standart (Şâfiî, Mâlikî, Hanbelî)'],
  'asrHanafi': ['الحنفي (المثلين)', 'Hanafi', 'Hanafite', 'حنفی', 'Hanafi', 'Hanefî'],
  'timesNote': ['المواقيت محسوبة فلكياً، وقد تختلف دقيقة أو دقيقتين عن تقويم مسجدك.', 'Times are calculated astronomically and may differ by a minute or two from your mosque.', "Les horaires sont calculés et peuvent différer d'une ou deux minutes de votre mosquée.", 'اوقات فلکیاتی حساب سے ہیں، آپ کی مسجد سے ایک دو منٹ کا فرق ہو سکتا ہے۔', 'Waktu dihitung secara astronomis dan bisa berbeda satu-dua menit dari masjid Anda.', 'Vakitler astronomik hesaplanır; caminizden bir iki dakika farklı olabilir.'],
  'statsTasbih': ['تسبيحة اليوم', 'tasbih today', "tasbih aujourd'hui", 'آج کی تسبیح', 'tasbih hari ini', 'bugün tesbih'],
  'statsIstighfar': ['استغفار اليوم', 'istighfar today', "istighfar aujourd'hui", 'آج کا استغفار', 'istighfar hari ini', 'bugün istiğfar'],
  'statsAdhkar': ['ذكراً أنجزته', 'adhkar done', 'adhkar faits', 'مکمل اذکار', 'dzikir selesai', 'tamamlanan zikir'],
  'thanksTitle': ['أشكرك يا ربي على نعمة', 'Thank You, my Lord, for the blessing of', 'Merci, mon Seigneur, pour le bienfait de', 'اے میرے رب! تیرا شکر ہے اس نعمت پر', 'Terima kasih ya Rabb atas nikmat', 'Rabbim, şu nimet için sana şükürler olsun:'],
  'ayahOfDay': ['آية اليوم', 'Verse of the day', 'Verset du jour', 'آج کی آیت', 'Ayat hari ini', 'Günün ayeti'],
  'waqfTitle': ['وقفٌ لله تعالى', 'An endowment for the sake of Allah', "Un waqf pour l'amour d'Allah", 'اللہ کی رضا کے لیے وقف', 'Wakaf karena Allah', "Allah rızası için vakıf"],
  'waqfText': ['هذا التطبيق صدقةٌ جارية عن صاحبه وعن والده. كلما قرأت آية أو ذكرت الله هنا، فلا تنسَهما من دعائك.', 'This app is an ongoing charity on behalf of its owner and his father. Whenever you read a verse or remember Allah here, please remember them in your prayers.', "Cette application est une aumône continue pour son auteur et son père. Chaque fois que vous lisez un verset ou invoquez Allah ici, pensez à eux dans vos prières.", 'یہ ایپ اپنے مالک اور ان کے والد کی طرف سے صدقۂ جاریہ ہے۔ جب بھی آپ یہاں کوئی آیت پڑھیں یا اللہ کا ذکر کریں تو انہیں اپنی دعاؤں میں یاد رکھیں۔', 'Aplikasi ini adalah sedekah jariyah atas nama pemiliknya dan ayahnya. Setiap kali Anda membaca ayat atau berdzikir di sini, doakanlah mereka.', 'Bu uygulama, sahibi ve babası adına sadaka-i câriyedir. Burada bir ayet okuduğunuzda veya Allah’ı zikrettiğinizde onları dualarınızda hatırlayın.'],
  'myPrayers': ['صلواتي اليوم', 'My prayers today', "Mes prières aujourd'hui", 'آج کی میری نمازیں', 'Salatku hari ini', 'Bugünkü namazlarım'],
  'searchSurah': ['ابحث عن سورة بالاسم أو الرقم', 'Search a surah by name or number', 'Chercher une sourate par nom ou numéro', 'نام یا نمبر سے سورت تلاش کریں', 'Cari surah dengan nama atau nomor', 'Sure adı veya numarası ile ara'],
  'continueReading': ['متابعة القراءة', 'Continue reading', 'Reprendre la lecture', 'پڑھائی جاری رکھیں', 'Lanjutkan membaca', 'Okumaya devam et'],
  'continue': ['تابع', 'Continue', 'Reprendre', 'جاری رکھیں', 'Lanjut', 'Devam'],
  'meccan': ['مكية', 'Meccan', 'Mecquoise', 'مکی', 'Makkiyah', 'Mekkî'],
  'medinan': ['مدنية', 'Medinan', 'Médinoise', 'مدنی', 'Madaniyah', 'Medenî'],
  'ayahs': ['{n} آية', '{n} verses', '{n} versets', '{n} آیات', '{n} ayat', '{n} ayet'],
  'translation': ['الترجمة', 'Translation', 'Traduction', 'ترجمہ', 'Terjemahan', 'Meal'],
  'markRead': ['أتممت قراءة السورة', 'I finished this surah', "J'ai fini cette sourate", 'میں نے یہ سورت مکمل کر لی', 'Saya selesai membaca surah ini', 'Bu sureyi bitirdim'],
  'surahDone': ['تمّت قراءتها ✓', 'Finished ✓', 'Terminée ✓', 'مکمل ✓', 'Selesai ✓', 'Bitti ✓'],
  'khatmah': ['ختمة القرآن', 'Quran completion', 'Lecture complète du Coran', 'ختمِ قرآن', 'Khatam Al-Quran', 'Hatim'],
  'khatmahProgress': ['قرأت {p}% من المصحف', 'You have read {p}% of the Quran', 'Vous avez lu {p}% du Coran', 'آپ نے قرآن کا {p}% پڑھ لیا', 'Anda telah membaca {p}% Al-Quran', "Kur'an'ın %{p} kadarını okudunuz"],
  'khatmahPlan': ['أريد الختم خلال', 'Finish within', 'Terminer en', 'اتنے دنوں میں ختم کریں', 'Selesaikan dalam', 'Şu sürede bitir'],
  'days': ['{n} يوماً', '{n} days', '{n} jours', '{n} دن', '{n} hari', '{n} gün'],
  'perDay': ['اقرأ {n} آية يومياً لتختم في موعدك', 'Read {n} verses a day to finish on time', 'Lisez {n} versets par jour pour finir à temps', 'وقت پر ختم کرنے کے لیے روزانہ {n} آیات پڑھیں', 'Baca {n} ayat per hari agar selesai tepat waktu', 'Zamanında bitirmek için günde {n} ayet okuyun'],
  'resetKhatmah': ['ختمة جديدة', 'Start a new khatmah', 'Nouvelle lecture', 'نیا ختم', 'Khatam baru', 'Yeni hatim'],
  'khatmahDone': ['ما شاء الله، أتممت ختم القرآن! تقبّل الله منك.', 'Masha Allah, you have completed the Quran! May Allah accept it from you.', 'Masha Allah, vous avez terminé le Coran ! Qu’Allah l’accepte de vous.', 'ماشاءاللہ، آپ نے قرآن مکمل کر لیا! اللہ قبول فرمائے۔', 'Masya Allah, Anda telah khatam! Semoga Allah menerimanya.', "Maşallah, hatmi tamamladınız! Allah kabul etsin."],
  'progress': ['أنجزت {d} من {n}', '{d} of {n} done', '{d} sur {n} faits', '{n} میں سے {d} مکمل', '{d} dari {n} selesai', '{n} içinden {d} tamam'],
  'restart': ['من جديد', 'Restart', 'Recommencer', 'دوبارہ', 'Ulangi', 'Baştan'],
  'repeat': ['التكرار', 'Repeat', 'Répéter', 'تکرار', 'Ulangi', 'Tekrar'],
  'done': ['تمّ بحمد الله', 'Done, praise be to Allah', 'Terminé, louange à Allah', 'الحمدللہ مکمل', 'Selesai, alhamdulillah', 'Tamam, elhamdülillah'],
  'copy': ['نسخ', 'Copy', 'Copier', 'کاپی', 'Salin', 'Kopyala'],
  'copied': ['تم النسخ', 'Copied', 'Copié', 'کاپی ہو گیا', 'Disalin', 'Kopyalandı'],
  'delete': ['حذف', 'Delete', 'Supprimer', 'حذف', 'Hapus', 'Sil'],
  'deleteQ': ['حذف هذا الذكر؟', 'Delete this dhikr?', 'Supprimer ce dhikr ?', 'یہ ذکر حذف کریں؟', 'Hapus dzikir ini?', 'Bu zikir silinsin mi?'],
  'cancel': ['إلغاء', 'Cancel', 'Annuler', 'منسوخ', 'Batal', 'İptal'],
  'addDhikr': ['ذكر أو دعاء جديد', 'New dhikr or dua', 'Nouveau dhikr ou dou‘a', 'نیا ذکر یا دعا', 'Dzikir atau doa baru', 'Yeni zikir veya dua'],
  'dhikrHint': ['اكتب الذكر أو الدعاء هنا', 'Write the dhikr or dua here', 'Écrivez le dhikr ou la dou‘a ici', 'یہاں ذکر یا دعا لکھیں', 'Tulis dzikir atau doa di sini', 'Zikri veya duayı buraya yazın'],
  'times': ['عدد المرات', 'Times', 'Fois', 'تعداد', 'Jumlah', 'Adet'],
  'add': ['إضافة', 'Add', 'Ajouter', 'شامل کریں', 'Tambah', 'Ekle'],
  'added': ['أُضيف إلى أذكارك', 'Added to your adhkar', 'Ajouté à vos adhkar', 'آپ کے اذکار میں شامل ہو گیا', 'Ditambahkan ke dzikir Anda', 'Zikirlerine eklendi'],
  'emptyMine': ['لم تضف أذكاراً بعد. اكتب أول ذكر أو دعاء في الخانة أعلاه ثم اضغط «إضافة».', 'You have not added any adhkar yet. Write your first one above, then tap Add.', "Vous n'avez encore rien ajouté. Écrivez votre premier dhikr ci-dessus puis touchez Ajouter.", 'آپ نے ابھی کوئی ذکر شامل نہیں کیا۔ اوپر پہلا ذکر لکھیں اور «شامل کریں» دبائیں۔', 'Anda belum menambahkan dzikir. Tulis yang pertama di atas lalu ketuk Tambah.', 'Henüz zikir eklemediniz. İlkini yukarıya yazıp Ekle’ye dokunun.'],
  'rounds': ['الدورات: {n}', 'Rounds: {n}', 'Tours : {n}', 'چکر: {n}', 'Putaran: {n}', 'Tur: {n}'],
  'todayTotal': ['مجموع اليوم: {n}', 'Today: {n}', "Aujourd'hui : {n}", 'آج کا مجموعہ: {n}', 'Hari ini: {n}', 'Bugün: {n}'],
  'resetCounter': ['تصفير العداد', 'Reset counter', 'Remettre à zéro', 'کاؤنٹر صفر کریں', 'Atur ulang', 'Sayacı sıfırla'],
  'of': ['من {n}', 'of {n}', 'sur {n}', '{n} میں سے', 'dari {n}', '{n} içinden'],
  'tapToCount': ['اضغط على الدائرة للتسبيح', 'Tap the circle to count', 'Touchez le cercle pour compter', 'گننے کے لیے دائرے کو دبائیں', 'Ketuk lingkaran untuk menghitung', 'Saymak için daireye dokun'],
  'names': ['أسماء الله الحسنى', 'The 99 Names of Allah', "Les 99 noms d'Allah", 'اللہ کے ننانوے نام', 'Asmaul Husna', 'Esmâ-ül Hüsnâ'],
  'nawawi': ['الأربعون النووية', "An-Nawawi's 40 Hadith", 'Les 40 hadiths de Nawawi', 'اربعین نووی', 'Hadits Arbain Nawawi', 'Nevevî’nin 40 Hadisi'],
  'hadithNum': ['الحديث {n}', 'Hadith {n}', 'Hadith {n}', 'حدیث {n}', 'Hadits {n}', 'Hadis {n}'],
  'hadithLangNote': ['', '', 'La traduction est en anglais.', 'ترجمہ انگریزی میں ہے۔', 'Terjemahan dalam bahasa Inggris.', 'Çeviri İngilizcedir.'],
  'qibla': ['اتجاه القبلة', 'Qibla direction', 'Direction de la Qibla', 'قبلہ رخ', 'Arah kiblat', 'Kıble yönü'],
  'qiblaDeg': ['القبلة على {d}° من الشمال', 'Qibla is {d}° from north', 'La Qibla est à {d}° du nord', 'قبلہ شمال سے {d}° پر ہے', 'Kiblat {d}° dari utara', 'Kıble kuzeyden {d}°'],
  'qiblaHint': ['ضع الهاتف أفقياً وأدِره حتى يشير السهم الأخضر إلى الأعلى.', 'Hold the phone flat and turn until the green arrow points up.', 'Tenez le téléphone à plat et tournez jusqu’à ce que la flèche verte pointe vers le haut.', 'فون کو سیدھا رکھیں اور گھمائیں یہاں تک کہ سبز تیر اوپر کی طرف ہو۔', 'Pegang ponsel mendatar dan putar hingga panah hijau menunjuk ke atas.', 'Telefonu düz tutun ve yeşil ok yukarıyı gösterene kadar dönün.'],
  'qiblaCalib': ['إذا بدا الاتجاه غير دقيق، حرّك الهاتف على شكل الرقم 8 عدة مرات، وابتعد عن المعادن والأجهزة.', 'If the direction looks off, move the phone in a figure-8 a few times and stay away from metal.', "Si la direction semble fausse, décrivez un 8 avec le téléphone et éloignez-vous du métal.", 'اگر سمت درست نہ لگے تو فون کو 8 کی شکل میں چند بار گھمائیں اور دھات سے دور رہیں۔', 'Jika arah terasa salah, gerakkan ponsel membentuk angka 8 dan jauhi logam.', 'Yön yanlış görünürse telefonu birkaç kez 8 çizerek hareket ettirin ve metalden uzak durun.'],
  'qiblaFacing': ['أنت متّجه إلى القبلة', 'You are facing the Qibla', 'Vous faites face à la Qibla', 'آپ کا رخ قبلہ کی طرف ہے', 'Anda menghadap kiblat', 'Kıbleye dönüksünüz'],
  'noCompass': ['لا يتوفر حسّاس البوصلة في هذا الجهاز. استخدم الدرجة المكتوبة أعلاه مع بوصلة عادية.', 'This device has no compass sensor. Use the degree above with a regular compass.', "Cet appareil n'a pas de boussole. Utilisez le degré ci-dessus avec une boussole.", 'اس آلے میں قطب نما سینسر نہیں ہے۔ اوپر دی گئی ڈگری کو عام قطب نما کے ساتھ استعمال کریں۔', 'Perangkat ini tidak punya kompas. Gunakan derajat di atas dengan kompas biasa.', 'Bu cihazda pusula yok. Yukarıdaki dereceyi normal bir pusulayla kullanın.'],
  'tracker': ['متابعة الصلوات', 'Prayer tracker', 'Suivi des prières', 'نماز ٹریکر', 'Pelacak salat', 'Namaz takibi'],
  'trackerSub': ['سجّل صلواتك كل يوم', 'Log your prayers every day', 'Notez vos prières chaque jour', 'روزانہ اپنی نمازیں درج کریں', 'Catat salat Anda setiap hari', 'Namazlarını her gün işaretle'],
  'streak': ['أيام متتالية بالصلوات الخمس: {n}', 'Days in a row with all five prayers: {n}', 'Jours consécutifs avec les cinq prières : {n}', 'پانچوں نمازوں کے مسلسل دن: {n}', 'Hari berturut-turut salat lima waktu: {n}', 'Beş vakit kılınan ardışık gün: {n}'],
  'last7': ['آخر سبعة أيام', 'Last 7 days', '7 derniers jours', 'پچھلے سات دن', '7 hari terakhir', 'Son 7 gün'],
  'calendar': ['التقويم الهجري', 'Hijri calendar', 'Calendrier hégirien', 'ہجری کیلنڈر', 'Kalender Hijriah', 'Hicri takvim'],
  'hijriAdjust': ['تعديل التاريخ الهجري', 'Adjust Hijri date', "Ajuster la date de l'hégire", 'ہجری تاریخ میں تبدیلی', 'Sesuaikan tanggal Hijriah', 'Hicri tarihi ayarla'],
  'hijriNote': ['التاريخ محسوب، وقد يختلف يوماً عن رؤية الهلال في بلدك.', 'The date is calculated and may differ by a day from the moon sighting in your country.', "La date est calculée et peut différer d'un jour de l'observation de la lune.", 'تاریخ حساب سے ہے، آپ کے ملک میں رویتِ ہلال سے ایک دن کا فرق ہو سکتا ہے۔', 'Tanggal dihitung dan bisa berbeda sehari dari rukyat di negara Anda.', 'Tarih hesaplanmıştır; ülkenizdeki hilal gözleminden bir gün farklı olabilir.'],
  'events': ['المناسبات القادمة', 'Upcoming occasions', 'Prochaines occasions', 'آنے والے مواقع', 'Hari besar mendatang', 'Yaklaşan günler'],
  'inDays': ['بعد {n} يوم', 'in {n} days', 'dans {n} jours', '{n} دن بعد', '{n} hari lagi', '{n} gün sonra'],
  'today': ['اليوم', 'Today', "Aujourd'hui", 'آج', 'Hari ini', 'Bugün'],
  'zakat': ['حاسبة الزكاة', 'Zakat calculator', 'Calcul de la zakat', 'زکوٰۃ کیلکولیٹر', 'Kalkulator zakat', 'Zekât hesaplayıcı'],
  'zakatCash': ['النقود والمدخرات', 'Cash and savings', 'Argent et épargne', 'نقدی اور بچت', 'Uang dan tabungan', 'Nakit ve birikim'],
  'zakatGoods': ['عروض التجارة', 'Trade goods', 'Marchandises', 'تجارتی مال', 'Barang dagangan', 'Ticaret malı'],
  'zakatGold': ['الذهب (غرام)', 'Gold (grams)', 'Or (grammes)', 'سونا (گرام)', 'Emas (gram)', 'Altın (gram)'],
  'zakatSilver': ['الفضة (غرام)', 'Silver (grams)', 'Argent métal (grammes)', 'چاندی (گرام)', 'Perak (gram)', 'Gümüş (gram)'],
  'zakatGoldPrice': ['سعر غرام الذهب', 'Price of 1 g of gold', "Prix d'1 g d'or", 'ایک گرام سونے کی قیمت', 'Harga 1 g emas', '1 g altın fiyatı'],
  'zakatSilverPrice': ['سعر غرام الفضة', 'Price of 1 g of silver', "Prix d'1 g d'argent", 'ایک گرام چاندی کی قیمت', 'Harga 1 g perak', '1 g gümüş fiyatı'],
  'zakatDebts': ['ديون عليك حالّة', 'Debts you owe now', 'Dettes à payer', 'آپ پر واجب الادا قرض', 'Utang yang jatuh tempo', 'Ödenmesi gereken borçlar'],
  'zakatTotal': ['مجموع المال الزكوي', 'Zakatable wealth', 'Patrimoine soumis', 'قابلِ زکوٰۃ مال', 'Harta wajib zakat', 'Zekâta tabi mal'],
  'zakatNisab': ['النصاب', 'Nisab', 'Nisab', 'نصاب', 'Nisab', 'Nisap'],
  'zakatDue': ['الزكاة الواجبة (2.5%)', 'Zakat due (2.5%)', 'Zakat due (2,5 %)', 'واجب زکوٰۃ (2.5%)', 'Zakat wajib (2,5%)', 'Verilecek zekât (%2,5)'],
  'zakatBelow': ['مالك دون النصاب، فلا زكاة عليه.', 'Your wealth is below the nisab, so no zakat is due.', "Votre patrimoine est sous le nisab : pas de zakat.", 'آپ کا مال نصاب سے کم ہے، زکوٰۃ واجب نہیں۔', 'Harta Anda di bawah nisab, tidak wajib zakat.', 'Malınız nisabın altında; zekât gerekmez.'],
  'zakatPriceNeeded': ['أدخل سعر غرام الذهب أو الفضة في عملتك لمعرفة النصاب.', 'Enter the price of a gram of gold or silver in your currency to know the nisab.', "Saisissez le prix d'un gramme d'or ou d'argent pour connaître le nisab.", 'نصاب جاننے کے لیے اپنی کرنسی میں سونے یا چاندی کے ایک گرام کی قیمت لکھیں۔', 'Masukkan harga per gram emas atau perak untuk mengetahui nisab.', 'Nisabı öğrenmek için gram altın veya gümüş fiyatını girin.'],
  'zakatNote': ['تجب الزكاة إذا بلغ المال النصاب (85 غرام ذهب أو 595 غرام فضة) ومرّ عليه عام هجري كامل. للحالات الخاصة استشر أهل العلم.', 'Zakat is due when wealth reaches the nisab (85 g of gold or 595 g of silver) and a full lunar year passes. For special cases, ask a scholar.', "La zakat est due quand le patrimoine atteint le nisab (85 g d'or ou 595 g d'argent) pendant une année lunaire. Pour les cas particuliers, consultez un savant.", 'جب مال نصاب (85 گرام سونا یا 595 گرام چاندی) کو پہنچے اور اس پر پورا قمری سال گزر جائے تو زکوٰۃ واجب ہے۔ خاص صورتوں میں علماء سے رجوع کریں۔', 'Zakat wajib jika harta mencapai nisab (85 g emas atau 595 g perak) dan genap satu tahun hijriah. Untuk kasus khusus, tanyakan kepada ulama.', 'Mal nisaba (85 g altın veya 595 g gümüş) ulaşıp üzerinden bir kameri yıl geçince zekât farz olur. Özel durumlar için bir âlime danışın.'],
  'settings': ['الإعدادات', 'Settings', 'Paramètres', 'ترتیبات', 'Pengaturan', 'Ayarlar'],
  'language': ['اللغة', 'Language', 'Langue', 'زبان', 'Bahasa', 'Dil'],
  'theme': ['المظهر', 'Appearance', 'Apparence', 'ظاہری شکل', 'Tampilan', 'Görünüm'],
  'themeSystem': ['حسب الجهاز', 'System', 'Système', 'سسٹم کے مطابق', 'Sistem', 'Sistem'],
  'themeLight': ['فاتح', 'Light', 'Clair', 'ہلکا', 'Terang', 'Açık'],
  'themeDark': ['داكن', 'Dark', 'Sombre', 'گہرا', 'Gelap', 'Koyu'],
  'adhanNotif': ['تنبيه عند دخول وقت الصلاة', 'Notify me at each prayer time', 'Me prévenir à chaque prière', 'ہر نماز کے وقت اطلاع دیں', 'Beri tahu saat waktu salat', 'Her namaz vaktinde bildir'],
  'notifDenied': ['لم يُسمح بالإشعارات. فعّلها من إعدادات الهاتف لتطبيق مأوى.', 'Notifications are not allowed. Turn them on for this app in your phone settings.', "Les notifications ne sont pas autorisées. Activez-les dans les réglages du téléphone.", 'اطلاعات کی اجازت نہیں ہے۔ فون کی ترتیبات میں اس ایپ کے لیے آن کریں۔', 'Notifikasi tidak diizinkan. Aktifkan di pengaturan ponsel.', 'Bildirimlere izin verilmedi. Telefon ayarlarından açın.'],
  'notifBody': ['حان الآن وقت صلاة {p}', 'It is time for {p} prayer', "C'est l'heure de la prière de {p}", '{p} کی نماز کا وقت ہو گیا ہے', 'Telah masuk waktu salat {p}', '{p} vakti girdi'],
  'reminders': ['التذكير بالذكر', 'Dhikr reminders', 'Rappels de dhikr', 'ذکر کی یاد دہانی', 'Pengingat dzikir', 'Zikir hatırlatıcı'],
  'remindersSub': ['يظهر لك ذكر قصير كل فترة وأنت تستخدم التطبيق. اضغط عليه إذا قلته ليُحسب.', 'A short dhikr appears from time to time while you use the app. Tap it after saying it to count it.', "Un court dhikr apparaît de temps en temps. Touchez-le après l'avoir dit pour le compter.", 'ایپ استعمال کرتے ہوئے وقفے وقفے سے مختصر ذکر ظاہر ہوگا۔ پڑھنے کے بعد اسے دبائیں تاکہ شمار ہو۔', 'Dzikir singkat muncul sesekali saat Anda memakai aplikasi. Ketuk setelah mengucapkannya.', 'Uygulamayı kullanırken arada kısa bir zikir çıkar. Söyledikten sonra dokunarak saydır.'],
  'remOff': ['إيقاف', 'Off', 'Désactivé', 'بند', 'Mati', 'Kapalı'],
  'remRare': ['نادر', 'Rare', 'Rare', 'کبھی کبھار', 'Jarang', 'Seyrek'],
  'remLow': ['منخفض', 'Low', 'Faible', 'کم', 'Rendah', 'Az'],
  'remMid': ['متوسط', 'Medium', 'Moyen', 'درمیانہ', 'Sedang', 'Orta'],
  'remHigh': ['عالي', 'High', 'Élevé', 'زیادہ', 'Tinggi', 'Sık'],
  'tapIfSaid': ['اضغط إذا قلتها', 'Tap if you said it', "Touchez si vous l'avez dit", 'پڑھ لیا ہو تو دبائیں', 'Ketuk jika sudah diucapkan', 'Söylediysen dokun'],
  'accepted': ['تقبّل الله منك', 'May Allah accept it from you', "Qu'Allah l'accepte de vous", 'اللہ قبول فرمائے', 'Semoga Allah menerimanya', 'Allah kabul etsin'],
  'about': ['عن التطبيق', 'About', 'À propos', 'ایپ کے بارے میں', 'Tentang', 'Hakkında'],
  'sources': ['نص المصحف بالرسم العثماني والترجمات من موسوعة القرآن الكريم وTanzil. الأربعون النووية: Dua Speed Reader Research (CC BY 4.0).', 'Uthmani Quran text and translations from QuranEnc and Tanzil. Nawawi 40: Dua Speed Reader Research (CC BY 4.0).', 'Texte coranique et traductions : QuranEnc et Tanzil. 40 hadiths : Dua Speed Reader Research (CC BY 4.0).', 'قرآن کا متن اور تراجم: QuranEnc اور Tanzil۔ اربعین نووی: Dua Speed Reader Research (CC BY 4.0)۔', 'Teks Al-Quran dan terjemahan dari QuranEnc dan Tanzil. Arbain Nawawi: Dua Speed Reader Research (CC BY 4.0).', "Kur'an metni ve mealler: QuranEnc ve Tanzil. 40 Hadis: Dua Speed Reader Research (CC BY 4.0)."],
  'qiblaFrom': ['من موقعك', 'from your location', 'depuis votre position', 'آپ کے مقام سے', 'dari lokasi Anda', 'konumunuzdan'],
};

const Map<String, List<List<String>>> _lists = {
  'thanks': [
    ['البصر', 'السمع', 'الإسلام', 'العافية', 'الأمن', 'الوالدين', 'العقل', 'الهداية', 'الرزق', 'الأهل', 'القرآن', 'النَّفَس'],
    ['sight', 'hearing', 'Islam', 'good health', 'safety', 'parents', 'reason', 'guidance', 'provision', 'family', 'the Quran', 'breath'],
    ['la vue', "l'ouïe", "l'islam", 'la santé', 'la sécurité', 'mes parents', 'la raison', 'la guidée', 'la subsistance', 'ma famille', 'le Coran', 'le souffle'],
    ['بینائی', 'سماعت', 'اسلام', 'عافیت', 'امن', 'والدین', 'عقل', 'ہدایت', 'رزق', 'گھر والے', 'قرآن', 'سانس'],
    ['penglihatan', 'pendengaran', 'Islam', 'kesehatan', 'keamanan', 'orang tua', 'akal', 'hidayah', 'rezeki', 'keluarga', 'Al-Quran', 'napas'],
    ['görme', 'işitme', 'İslam', 'sağlık', 'güven', 'anne baba', 'akıl', 'hidayet', 'rızık', 'aile', "Kur'an", 'nefes'],
  ],
  'hijriMonths': [
    ['محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر', 'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'],
    ['Muharram', 'Safar', 'Rabi al-Awwal', 'Rabi al-Akhir', 'Jumada al-Ula', 'Jumada al-Akhirah', 'Rajab', 'Shaban', 'Ramadan', 'Shawwal', 'Dhul-Qadah', 'Dhul-Hijjah'],
    ['Mouharram', 'Safar', 'Rabi al-Awwal', 'Rabi ath-Thani', 'Joumada al-Oula', 'Joumada ath-Thania', 'Rajab', 'Chaabane', 'Ramadan', 'Chawwal', 'Dhou al-Qi‘da', 'Dhou al-Hijja'],
    ['محرم', 'صفر', 'ربیع الاول', 'ربیع الثانی', 'جمادی الاول', 'جمادی الثانی', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذوالقعدہ', 'ذوالحجہ'],
    ['Muharram', 'Safar', 'Rabiul Awal', 'Rabiul Akhir', 'Jumadil Awal', 'Jumadil Akhir', 'Rajab', "Sya'ban", 'Ramadhan', 'Syawal', "Dzulqa'dah", 'Dzulhijjah'],
    ['Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir', 'Cemaziyelevvel', 'Cemaziyelahir', 'Recep', 'Şaban', 'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce'],
  ],
  // newYear, ashura, ramadan, eidFitr, arafah, eidAdha
  'events': [
    ['رأس السنة الهجرية', 'يوم عاشوراء', 'بداية رمضان', 'عيد الفطر', 'يوم عرفة', 'عيد الأضحى'],
    ['Islamic New Year', 'Day of Ashura', 'Start of Ramadan', 'Eid al-Fitr', 'Day of Arafah', 'Eid al-Adha'],
    ["Nouvel an de l'hégire", 'Achoura', 'Début du Ramadan', "Aïd al-Fitr", "Jour d'Arafat", "Aïd al-Adha"],
    ['اسلامی نیا سال', 'یومِ عاشور', 'رمضان کا آغاز', 'عید الفطر', 'یومِ عرفہ', 'عید الاضحیٰ'],
    ['Tahun Baru Hijriah', 'Hari Asyura', 'Awal Ramadhan', 'Idul Fitri', 'Hari Arafah', 'Idul Adha'],
    ['Hicri Yılbaşı', 'Aşure Günü', 'Ramazan Başlangıcı', 'Ramazan Bayramı', 'Arefe Günü', 'Kurban Bayramı'],
  ],
};

/// Adhkar category names.
const Map<String, List<String>> kCatNames = {
  'morning': ['الصباح', 'Morning', 'Matin', 'صبح', 'Pagi', 'Sabah'],
  'evening': ['المساء', 'Evening', 'Soir', 'شام', 'Petang', 'Akşam'],
  'prayer': ['بعد الصلاة', 'After prayer', 'Après la prière', 'نماز کے بعد', 'Setelah salat', 'Namazdan sonra'],
  'sleep': ['النوم', 'Sleep', 'Sommeil', 'سونے سے پہلے', 'Tidur', 'Uyku'],
  'wake': ['الاستيقاظ', 'Waking up', 'Réveil', 'جاگنے پر', 'Bangun tidur', 'Uyanınca'],
  'mosque': ['المسجد', 'Mosque', 'Mosquée', 'مسجد', 'Masjid', 'Cami'],
  'duas': ['أدعية مأثورة', 'Well-known duas', 'Invocations', 'مسنون دعائیں', 'Doa-doa', 'Dualar'],
  'parents': ['للوالدين', 'For parents', 'Pour les parents', 'والدین کے لیے', 'Untuk orang tua', 'Anne baba için'],
  'mine': ['أذكاري', 'My adhkar', 'Mes adhkar', 'میرے اذکار', 'Dzikirku', 'Zikirlerim'],
};
String catName(String id) => kCatNames[id]![_li];

/// Translations of the short Arabic notes attached to some adhkar (split on " · ").
const Map<String, List<String>> _noteParts = {
  'آخر آيتين من سورة البقرة': ['Last two verses of Al-Baqarah', "Les deux derniers versets d'Al-Baqara", 'سورۃ البقرہ کی آخری دو آیات', 'Dua ayat terakhir Al-Baqarah', 'Bakara suresinin son iki ayeti'],
  'آية الكرسي': ['Ayat al-Kursi', 'Ayat al-Koursi', 'آیت الکرسی', 'Ayat Kursi', 'Âyetü’l-Kürsî'],
  'بعد الأذان': ['After the adhan', "Après l'adhan", 'اذان کے بعد', 'Setelah azan', 'Ezandan sonra'],
  'بعد الترديد مع المؤذن': ['after repeating after the muezzin', 'après avoir répété après le muezzin', 'مؤذن کے ساتھ دہرانے کے بعد', 'setelah menjawab muazin', 'müezzini tekrarladıktan sonra'],
  'تمام المئة': ['Completes the hundred', 'Complète la centaine', 'سو پورا کرنے کے لیے', 'Penyempurna seratus', 'Yüzü tamamlar'],
  'دعاء ذي النون': ['Dua of Yunus', 'Invocation de Younous', 'حضرت یونسؑ کی دعا', 'Doa Nabi Yunus', 'Hz. Yunus’un duası'],
  'سورة آل عمران': ['Surah Al Imran', 'Sourate Al Imran', 'سورۃ آل عمران', 'Surah Ali Imran', 'Âl-i İmrân suresi'],
  'سورة إبراهيم': ['Surah Ibrahim', 'Sourate Ibrahim', 'سورۃ ابراہیم', 'Surah Ibrahim', 'İbrahim suresi'],
  'سورة الأحقاف': ['Surah Al-Ahqaf', 'Sourate Al-Ahqaf', 'سورۃ الاحقاف', 'Surah Al-Ahqaf', 'Ahkâf suresi'],
  'سورة الإخلاص': ['Surah Al-Ikhlas', 'Sourate Al-Ikhlas', 'سورۃ الاخلاص', 'Surah Al-Ikhlas', 'İhlâs suresi'],
  'سورة الإسراء': ['Surah Al-Isra', 'Sourate Al-Isra', 'سورۃ الاسراء', "Surah Al-Isra'", 'İsrâ suresi'],
  'سورة البقرة': ['Surah Al-Baqarah', 'Sourate Al-Baqara', 'سورۃ البقرہ', 'Surah Al-Baqarah', 'Bakara suresi'],
  'سورة الفلق': ['Surah Al-Falaq', 'Sourate Al-Falaq', 'سورۃ الفلق', 'Surah Al-Falaq', 'Felak suresi'],
  'سورة الناس': ['Surah An-Nas', 'Sourate An-Nas', 'سورۃ الناس', 'Surah An-Nas', 'Nâs suresi'],
  'سورة طه': ['Surah Taha', 'Sourate Taha', 'سورۃ طٰہٰ', 'Surah Taha', 'Tâhâ suresi'],
  'سورة نوح': ['Surah Nuh', 'Sourate Nouh', 'سورۃ نوح', 'Surah Nuh', 'Nûh suresi'],
  'سورة الأنبياء': ['Surah Al-Anbiya', "Sourate Al-Anbiya", 'سورۃ الانبیاء', "Surah Al-Anbiya'", 'Enbiyâ suresi'],
  'سيد الاستغفار': ['The master supplication for forgiveness', 'La meilleure demande de pardon', 'سید الاستغفار', 'Sayyidul Istighfar', 'Seyyidü’l-İstiğfâr'],
  'ثلاث مرات بعد الفجر والمغرب': ['three times after Fajr and Maghrib', 'trois fois après Fajr et Maghrib', 'فجر اور مغرب کے بعد تین مرتبہ', 'tiga kali setelah Subuh dan Maghrib', 'sabah ve akşam namazından sonra üç kez'],
  'مع النفث في الكفين والمسح على الجسد': ['blow into the palms and wipe over the body', 'souffler dans les paumes et passer sur le corps', 'ہتھیلیوں میں پھونک کر جسم پر پھیریں', 'tiupkan ke telapak tangan lalu usapkan ke tubuh', 'avuçlara üfleyip vücuda sürün'],
  'عند الخروج من المسجد': ['When leaving the mosque', 'En sortant de la mosquée', 'مسجد سے نکلتے وقت', 'Ketika keluar masjid', 'Camiden çıkarken'],
  'بالرجل اليسرى': ['with the left foot', 'du pied gauche', 'بائیں پاؤں سے', 'dengan kaki kiri', 'sol ayakla'],
  'عند الذهاب إلى المسجد': ['When going to the mosque', 'En allant à la mosquée', 'مسجد جاتے وقت', 'Ketika berangkat ke masjid', 'Camiye giderken'],
  'عند دخول المسجد': ['When entering the mosque', 'En entrant dans la mosquée', 'مسجد میں داخل ہوتے وقت', 'Ketika masuk masjid', 'Camiye girerken'],
  'بالرجل اليمنى': ['with the right foot', 'du pied droit', 'دائیں پاؤں سے', 'dengan kaki kanan', 'sağ ayakla'],
  'لمن استيقظ من الليل': ['For one who wakes up at night', 'Pour qui se réveille la nuit', 'رات کو جاگنے والے کے لیے', 'Bagi yang terbangun di malam hari', 'Gece uyanan için'],
  'من أواخر سورة آل عمران': ['From the end of Surah Al Imran', 'De la fin de la sourate Al Imran', 'سورۃ آل عمران کے آخر سے', 'Dari akhir Surah Ali Imran', 'Âl-i İmrân suresinin sonundan'],
};

String noteText(String ar) {
  if (ar.isEmpty || _li == 0) return ar;
  return ar.split(' · ').map((p) => _noteParts[p]?[_li - 1] ?? p).join(' · ');
}
