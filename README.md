# Dersini Bil

Dersini Bil, ogrenciler ve ogretmenler icin hazirlanmis Flutter tabanli ders takip ve odev yonetim uygulamasidir. Demo proje gercek backend kullanmadan calisir; login, e-posta dogrulama simulasyonu, rol secimi, mock servis verisi, yerel depolama, grafik ve bildirim akislari sunum icin hazirdir.

## Kullanilan Teknolojiler

- Flutter ve Dart
- Provider ile state management
- SharedPreferences ile yerel depolama
- fl_chart ile net ve soru gelisim grafigi
- flutter_local_notifications ile odev ve ders hatirlaticilari
- Mock servis katmani ile sinifa gore konu verisi

## Ana Akis

1. Splash ekrani
2. Login ekrani
3. Snackbar ile e-posta dogrulama simulasyonu
4. Ogrenci / Ogretmen rol secimi
5. Role gore ayrilan ana panel

Demo login icin herhangi bir e-posta ve sifre kabul edilir. Varsayilan ekranlarda `demo@dersinibil.com` ve `123456` yazilidir.

## Ogrenci Ozellikleri

- Sinif secimi: 5. siniftan mezun / sinava hazirlik seviyesine kadar
- `ClassTopicService` ile sinifa gore ders ve konu verisi
- Konu tamamlama ve ders bazli progress bar
- Odev ekleme, teslim tarihi secme, tamamlandi isaretleme
- Odev teslim zamanina gore local notification planlama
- Gunluk soru ve deneme neti girisi
- fl_chart cizgi grafigiyle gelisim takibi
- Not ekleme, duzenleme, silme ve yerel depolama
- `OGR123` mock koduyla ogretmen eslesmesi

## Ogretmen Ozellikleri

- Ozel ders / okul dersi takip modu
- Ogretmen ana sayfasinda ders, ogrenci ve odev ozeti
- Ogrenci listesi ve detay ekranina veri aktarimi
- Ders programi ekleme, DatePicker ve TimePicker kullanimi
- Ders saatine gore local notification planlama
- Ogrenciye ders bazli odev atama
- Ders alani siniflandirma ve profil etiketleri
- Mock eslesme kodu: `OGR123`

## Ders Isterleri Karsiligi

- En az 5 on yuz tasarimi: Login, rol secimi, ogrenci ana sayfa, konu takibi, odevler, grafikler, ogretmen ana sayfa, ogrenciler, program, odev atama ve profil ekranlari eklendi.
- UI elemanlari: Column, Row, Stack, ListView, GridView, Card, TextField, DropdownButtonFormField, BottomNavigationBar, TabBar, Checkbox, Switch, DatePicker, TimePicker, Dialog ve Snackbar kullanildi.
- Ileri ozellik: `flutter_local_notifications` ile odev ve ders hatirlaticilari eklendi.
- Servisten veri alma: `ClassTopicService`, mock JSON benzeri veri yapisindan sinifa gore konulari async olarak dondurur ve `FutureBuilder` ile ekranda gosterilir.
- Yerel depolama: rol, sinif secimi, odevler, notlar, konu tamamlanma durumlari ve ilerleme girdileri SharedPreferences ile saklanir.
- 3rd party kutuphaneler: provider, shared_preferences, fl_chart, flutter_local_notifications kullanildi.

## Proje Yapisi

```text
lib/
  main.dart
  app.dart
  models/
  services/
  screens/
    student/
    teacher/
  widgets/
  utils/
```

## Calistirma

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Bagli cihazlari gormek icin:

```bash
flutter devices
```

## Notlar

- Uygulama backend veya Firebase gerektirmez.
- Android bildirim izni icin `POST_NOTIFICATIONS` manifest izni eklenmistir.
- iOS ve Android bildirim izinleri `NotificationService` icinde talep edilir.
