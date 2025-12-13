import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final Color inputFillColor;
  final Color hintTextColor;
  final TextEditingController? controller;
  final bool isPassword;
  final bool hasError;
  final Color errorColor;
  final TextInputType keyboardType;

  // YENİ: Harici olarak göz simgesini veya başka bir ikonu almak için
  final Widget? suffixIcon;

  // Tüm parametreleri alan constructor
  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.inputFillColor,
    required this.hintTextColor,
    this.controller,
    this.isPassword = false,
    this.hasError = false,
    this.errorColor = Colors.red,
    this.keyboardType = TextInputType.text,
    this.suffixIcon, // YENİ: Constructor'a ekledik
  });

  @override
  Widget build(BuildContext context) {
    // Sınır (Border) stillerini oluşturma
    final Color defaultBorderColor = hintTextColor.withOpacity(0.5);
    final Color primaryColor = Colors.blue; // Odaklanma rengi için

    final OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: defaultBorderColor, width: 1.0),
    );

    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    );

    final OutlineInputBorder focusedStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      // HATA VARSA ERROR BORDER'I KULLAN
      borderSide: BorderSide(
        color: hasError ? errorColor : primaryColor,
        width: hasError ? 2.0 : 2.0, // Hata varsa da kalınlık aynı olabilir
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiket (Label) metni
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Metin Giriş Alanı (TextFormField)
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          // Şifre görünürlüğünü isPassword'dan alıyor
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor),
            filled: true,
            fillColor: inputFillColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),

            // ESKİ VE STATİK İKON MANTIĞI KALDIRILDI.
            // YENİ: Harici olarak gelen suffixIcon kullanılıyor.
            // Böylece CreateAccountScreen'de eklediğimiz toggle butonu görünecektir.
            suffixIcon: suffixIcon,

            // Kenarlık (Border) Ayarları
            enabledBorder: hasError ? errorBorder : defaultBorder,

            // 2. focusedBorder: Alana odaklanıldığında (Hata varsa yine kırmızı olsun)
            focusedBorder: focusedStyle,

            // 3. border: Geri kalan tüm durumlar için varsayılan (Yine hatayı kapsayacak)
            border: hasError ? errorBorder : defaultBorder,

            // 4. errorBorder & focusedErrorBorder: Bunlar da hata sınırını göstermeli (Güvenlik için)
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
          ),
        ),
      ],
    );
  }
}
