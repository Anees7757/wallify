# Wallify

Wallify is a beautifully designed wallpaper app that provides users with a wide range of high-quality wallpapers. The app includes smooth animations and an intuitive UI, allowing users to set wallpapers to their home screen, lock screen, or both with ease.

## Features

- **High-Quality Wallpapers**: Browse and download a vast collection of high-resolution wallpapers.
- **Beautiful UI**: Enjoy a clean and aesthetically pleasing user interface.
- **Smooth Animations**: Experience fluid and engaging animations throughout the app.
- **Wallpaper Settings**: Set wallpapers to your home screen, lock screen, or both.
- **Favorites**: Save your favorite wallpapers for quick access.
- **Categories**: Explore wallpapers categorized by themes and styles.
- **Search**: Find specific wallpapers using the search functionality.
- **Unsplash API Integration**: Fetch wallpapers from the Unsplash API.

## Technologies Used

- **Frontend**: Flutter (for mobile interface)
- **Backend**: Unsplash API for fetching wallpapers

## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)

### Setup

1. Clone the repository
    ```bash
    git clone https://github.com/YOUR_USERNAME/wallify.git
    cd wallify
    ```

2. Install dependencies
    ```bash
    flutter pub get
    ```

3. Set up the Unsplash API
    - Create an account on [Unsplash](https://unsplash.com/developers)
    - Create a new application to get your API key
    - Add your Unsplash API key to your Flutter project

### Android

Make sure following permissions are included and configurations in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.SET_WALLPAPER"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>