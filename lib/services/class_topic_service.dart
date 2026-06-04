import '../models/topic_model.dart';
import '../utils/constants.dart';

class ClassTopicService {
  Future<Map<String, List<Topic>>> fetchTopicsForClass(String classLevel) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final data = _topics[classLevel] ?? _topics['8. sınıf']!;
    return data.map(
      (subject, titles) => MapEntry(
        subject,
        [
          for (final title in titles)
            Topic(
              id: '${classLevel}_${subject}_$title',
              subject: subject,
              title: title,
            ),
        ],
      ),
    );
  }

  static final Map<String, Map<String, List<String>>> _topics = {
    for (final level in AppConstants.classLevels)
      level: {
        'Matematik': _math(level),
        'Türkçe': _turkish(level),
        'Fen Bilimleri': _science(level),
        'Sosyal Bilgiler': _social(level),
        'İngilizce': ['Vocabulary', 'Grammar', 'Reading', 'Listening'],
      },
  };

  static List<String> _math(String level) => level == '8. sınıf'
      ? [
          'Çarpanlar ve Katlar',
          'Üslü İfadeler',
          'Kareköklü İfadeler',
          'Veri Analizi',
          'Olasılık',
          'Cebirsel İfadeler',
          'Doğrusal Denklemler',
          'Üçgenler',
          'Dönüşüm Geometrisi',
        ]
      : ['Doğal Sayılar', 'Kesirler', 'Oran Orantı', 'Problemler', 'Geometri'];

  static List<String> _turkish(String level) => level == '8. sınıf'
      ? [
          'Fiilimsi',
          'Cümlede Anlam',
          'Paragraf',
          'Sözcükte Anlam',
          'Yazım Kuralları',
          'Noktalama İşaretleri',
        ]
      : ['Sözcükte Anlam', 'Cümlede Anlam', 'Paragraf', 'Dil Bilgisi'];

  static List<String> _science(String level) => level == '8. sınıf'
      ? [
          'Mevsimler ve İklim',
          'DNA ve Genetik Kod',
          'Basınç',
          'Madde ve Endüstri',
          'Basit Makineler',
          'Enerji Dönüşümleri',
        ]
      : ['Canlılar', 'Kuvvet ve Hareket', 'Madde', 'Elektrik', 'Dünya ve Evren'];

  static List<String> _social(String level) => level == '8. sınıf'
      ? ['İnkılap Tarihi', 'Milli Uyanış', 'Atatürkçülük', 'Çağdaş Türkiye']
      : ['Kültür ve Miras', 'İnsanlar ve Yerler', 'Üretim', 'Vatandaşlık'];
}
