# MiWiFi

MiWiFi is an app that lets you add any WiFi network and its credentials and will generate a QR code for you using the [QRettyCode](https://github.com/mredig/QRettyCode) framework. This makes it much easier to allow people to join your wifi network without revealing your password. All passwords are stored securely in Keychain.

---

### Why & Why?
First off, it's not the best experience having guests over and when they ask to connect to your WiFi network you have to look around for your password and network name to read off to them. It also isn't very smart to give anyone your password to pretty much anything. MiWIFi is great because it works with your friends who have Android phones as well, assuming their phones have the smarts to connect to WiFi networks with a QR code.

Secondly, this app is a side project while I am still attending Lambda. I made it 100% programmatically. I wanted the experience of building an iOS app without using a single storyboard to gain more knowledge about UIKit.

I hope you enjoy MiWiFi!

### Future Features
- [X] Ability to add your ISP information for quick access
- [ ] Custom QR Code theme selection for user
- [ ] iPad and Apple Watch counter part
- [ ] CloudKit (sync support for iPad and Apple Watch)

#### Might do this:
- [ ] CoreLocation - Brings the most relevant (based on your location) WiFi network to the top of the list
- [ ] QR code "Corrupt Mode" -> Will make the QR code unreadable until password or FaceID passes



## Screenshots
---
<img src="EmptyState.png" width="400"> <img src="MainScreen.png" width="400">
<img src="AddNetwork.png" width="400"> <img src="TableViewContextMenu.png" width="400">
<img src="FaceIDRevealPass.png" width="400"> <img src="QRContextmenu.png" width="400">
<img src="Acknowledgements.png" width="400"> <img src="Settings.png" width="400">
