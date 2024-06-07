[![Video Label](https://img.shields.io/badge/Firebase-Google_Firebase-firebase?style=flat&logo=firebase&color=%23FFCA28)](https://youtu.be/SKkGWU1vBoI?si=Iyx2Lv9GUNbfZxlN)
<h1 align="center">🌏Sinking Earth🌏</h1>
<p align="center"><i>"To save the Sinking Earth, We must become Thinking Us."</i></p>
<div align="center">
<img src="https://img.shields.io/badge/Version-v2.0.0-version?style=flat&color=%23EA4335"/>
<img src="https://img.shields.io/badge/devpost-Global_Gamers_Challenge-devpost?style=flat&logo=devpost&logoColor=devpost&color=%23003E54"/>
<img src="https://img.shields.io/badge/Flutter-v3.19-flutter?style=flat&logo=flutter&color=%2302569B"/>
<img src="https://img.shields.io/badge/Firebase-Google_Firebase-firebase?style=flat&logo=firebase&color=%23FFCA28"/>
<!--img src="https://img.shields.io/badge/Google-Sponsored%20by%20google-google?style=flat&logo=google&color=%234285F4"/-->
</div>
<p align="center">This project has won 🏆<i>"Honorable Prize"</i>🏆 at Global Gamers Challenge!</p>

## 🔗Try Our Game
- Web: [https://sinkingus.web.app/](https://sinkingus.web.app/) (Not recommanded for mobile)
- IOS: Please run ```flutter build ios --release```
- Android: [Download](https://firebasestorage.googleapis.com/v0/b/sinkingus.appspot.com/o/apk%2Fapp-release.apk?alt=media&token=64137e94-4c2e-4914-b8f2-4d6719f808dc)

## 👥Contributors: Team Thinking Us
|🎮Game|🖥️Flutter Environment|🎨Design|
|:---:|:---:|:---:|
|<img src="https://github.com/eunjijeon11.png">|<img src="https://github.com/fivebellhyun.png">|<img src="https://github.com/sy318.png">|
|[Eunji Chon](https://github.com/eunjijeon11)|[Jonghyun Oh](https://github.com/fivebellhyun)|[Suyeon Jeong](https://github.com/sy318)|

## 💡Inspiration
We wanted to incorporate as many real-world elements related to environmental, economic, and social factors into the game as possible, and we thought a simulation game would be suitable. Sinking Earth allows users to experience and utilize various sustainable development elements centered around the environment as game mechanics.

## 🌱What it does
"Sinking Earth" is a simulation game themed around environmental protection and survival. Players must maintain their environmental score for 7 days before the Earth sinks, while also purchasing essentials to survive. In the game, players can choose from various professions, each with unique abilities and victory conditions. Players' choices shape the outcome of the game and can determine the fate of the Earth. Join forces to save the Earth and create a new future together!

## 👩🏻‍💻How we built it
For user account management, we leveraged Firestore, a robust database system provided by Firebase. As for the game development, we employed the Flame engine, a versatile game engine compatible with Flutter, and integrated it with Real-time Firebase services. This combination allowed us to create a seamless user experience with real-time updates and interactions in the game environment.

## 💦Challenges we ran into
In order to implement real-time multiplayer gaming, we intended to use Nakama as the game backend. However, we determined that using Nakama in Flutter was not yet stabilized, and we had to overhaul the project that was already well underway. Since then, we proceeded without a backend and used a method of reading and writing to a real-time database.

## 😎Accomplishments that we're proud of
Flame's collider did not have a feature to prevent passing through like a wall. Therefore we had to calculate directly based on the intersection of the character collider and the wall collider. It was a very difficult and trial-and-error process, but it was satisfying to have implemented the collision feature ourselves. I read this reference, and I hope you find it helpful in similar situations.

## 👍🏻What we learned
While developing this game, we explored environmental policies from various countries and incorporated them into our code. We learned that even for similar items, consumers can make environmentally friendly choices if they are a little more aware. We realized that we are not just coders, but we can also manifest our commitment to the environment through our code.

## 🔥What's next for Sinking Earth (Thinking Us)
I would like to start by improving the multiplayer environment to run more smoothly. I want to diversify the user experience by allowing players to choose the number of participants and the types of maps available in the game.
