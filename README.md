# Talkien_Voice_Call_App
A simple WebRTC Implementation with Viper architecture and Firebase as signalling server.

<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/lowkeyboard/Talkien_Voice_Call_App">
    <img src="Talkien/images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Talkien</h3>

  <p align="center">
    Google WebRTC and Firebase powered voice calling mobile app to connect with peers written in Swift 5.
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

![Alt Text](https://media.giphy.com/media/sAVf03gbOId35WEcD1/giphy.gif)

The project uses Firebase Real Time Database as a service for WebRTC Signalling. After the exchange of keys, connection for voice call will be established.

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

- [Swift](https://docs.swift.org/swift-book/)
- [Firebase](http://firebase.google.com)
- [GoogleWebRTC](https://cocoapods.org/pods/GoogleWebRTC)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- Cocoapods
  ```sh
  pod init
  ```
- Firebase

```
  Make sure to enable Firebase Real Time Database's read/write permissions to exchange signalling.
```

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/lowkeyboard/Talkien_Voice_Call_App.git
   ```
2. Install pod packages
   ```sh
   pod install
   ```
3. Change the file `GoogleService-Info` with your config file.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## Usage

After typing the name of the caller and callee in the first page, press to "send offer" button to send offer to Firebase,
wait for callee to do the same and after signalling has completed, voice call connection will be established.

_For more examples, please refer to the [Documentation](https://webrtc.googlesource.com/src/+/refs/heads/main/examples/objc/AppRTCMobile)_

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] Signalling
- [x] Voice Call
- [] CallKit UI
  - [] Call Duration

See the [open issues](https://github.com/lowkeyboard/Talkien_Voice_Call_App/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/lowkeyboard/Talkien_Voice_Call_App.svg?style=for-the-badge
[contributors-url]: https://github.com/lowkeyboard/Talkien_Voice_Call_App/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/lowkeyboard/Talkien_Voice_Call_App.svg?style=for-the-badge
[forks-url]: https://github.com/lowkeyboard/Talkien_Voice_Call_App/network/members
[stars-shield]: https://img.shields.io/github/stars/lowkeyboard/Talkien_Voice_Call_App.svg?style=for-the-badge
[stars-url]: https://github.com/lowkeyboard/Talkien_Voice_Call_App/stargazers
[issues-shield]: https://img.shields.io/github/issues/lowkeyboard/Talkien_Voice_Call_App.svg?style=for-the-badge
[issues-url]: https://github.com/lowkeyboard/Talkien_Voice_Call_App/issues
