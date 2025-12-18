# 📰 MyTech Case - Haber Uygulaması

Bu proje, içerisinde Kayıt ol / Giriş Yap, Kaynaklar, Haberler, Twitter sayfalarını barındırmaktadır. MVVM Mimarisi ile geliştirilmiştir.

## 🚀 Öne Çıkan Özellikler

* ⚡ **Hızlı Başlangıç:** Popüler haberler **Hive** ile cache'lenerek anında yüklenir.
* 🔄 **Sonsuz Kaydırma:** Haber listeleri **Infinite Scroll Pagination** ile sayfa sayfa yüklenir, bellek kullanımı minimize edilir.
* 🧠 **Dinamik Durum:** Tüm uygulama akışı **Riverpod** StateNotifier yapısıyla yönetilir.
* 🔑 **Güvenli Kimlik Doğrulama:** Token tabanlı giriş sistemi ve şifreli veri depolama.

## 🛠️ Teknik Yığın (Tech Stack)

| Araç | Kullanım Amacı |
| :--- | :--- |
| **Riverpod** | Global State Management & Dependency Injection |
| **Hive** | Haber Cacheleme |
| **Infinite Scroll Pagination** | Pürüzsüz ve performanslı liste kaydırma deneyimi |
| **Dio** | API Haberleşmesi ve Interceptor Yönetimi |
| **Secure Storage** | Hassas Verilerin (Auth Token) Güvenli Depolanması |



## 📱 Uygulama Demosu

<p align="center">
  <video src="assets/ekrankaydi.mp4" width="300" />
</p>

## ⚙️ Kurulum
1. `flutter pub get`
2. `flutter pub run build_runner build`
3. `flutter run`




