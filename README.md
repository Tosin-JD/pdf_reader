# JustRead - Lightweight and Powerful PDF Reader

JustRead is a fast, intuitive, and feature-rich PDF reader built with Flutter. Designed for simplicity and usability, JustRead allows users to view, search, zoom, and manage PDF documents with ease.

---

## ✨ Features

* **Search Functionality**: Quickly find keywords or phrases within any PDF.
* **Toggle Fullscreen**: Tap once to enter fullscreen mode for immersive reading.
* **Restore Last Opened PDF**: Automatically resumes the last opened file.
* **Restore Last Page**: Opens your document exactly where you left off.
* **Double-Tap to Zoom**: Smooth zoom-in/zoom-out with a simple double-tap.
* **Screen Rotation Lock**: Floating button to toggle orientation lock.
* **Keep Screen Awake**: Prevents your device from sleeping while reading.
* **Share PDF or Page**: Share the entire document or a specific page easily.
* **Print PDF**: Print documents directly from the app.
* **File Info in Popup Menu**: View detailed file information (size, path, etc).
* **Toggle Dark/Light Mode**: Choose a theme that suits your eyes.
* **Default Zoom Level**: Set your preferred zoom level for opening PDFs.
* **Book Library**: Organize and access all your PDFs in one place.
* **Bookmark Pages**: Mark important pages and jump back to them anytime.

---

## 🌟 Why JustRead?

Unlike bloated readers, JustRead focuses on core features and performance:

* Offline-friendly: No internet connection needed.
* Lightweight and fast: Opens large PDFs without lag.
* Privacy-first: Your data stays on your device.

---

## 💪 Built With

* [Flutter](https://flutter.dev/) – for cross-platform development
* [Dart](https://dart.dev/) – backend logic

---

## 🚀 Getting Started

To build or run locally:

```bash
flutter pub get
flutter run
```

To build a release version:

```bash
flutter build appbundle
```

> **Note**: Make sure you have a valid `key.properties` file and release keystore for production builds.

---

## 📦 Keystore (Security Notice)

**Never commit your keystore or `key.properties` to GitHub.**

Add to `.gitignore`:

```
android/key.properties
android/app/justread_keystore.jks
```

---

## 🛠️ Configuration

In `android/key.properties`:

```
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=justreadkey
storeFile=justread_keystore.jks
```

---

## 📱 Screenshots

*(Add screenshots of your app here)*

---

## 💪 Contributing

Contributions are welcome! If you have ideas for improvements, bug fixes, or new features:

1. Fork the repository
2. Create a branch (`feature/your-feature`)
3. Commit your changes
4. Open a pull request

---

## 🚗 Roadmap

* Cloud sync for bookmarks
* PDF annotations and highlighting
* Night mode auto-toggle
* Multi-tab reading

---

## 🛡️ License

MIT License. See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Special thanks to the Flutter community for the amazing tools and support.

---

## 📄 Contact

Oluwatosin Durodola
[justread.app](https://your-link-here.com) (add your website if available)
Email: [your\_email@example.com](mailto:your_email@example.com)
