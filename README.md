# 16052488
Mobile Computing Coursework

University (module: Mobile Computing) project. I used the Swift programming language and Xcode to create a game I named 'Bird Bounce'.
The aim of the game is for the player to shoot the birds to gain points. By meeting the level points goal the player is 
progressed to the next level, the game consists of 3 levels in total, after which, the game is completed 
and can be played again from the beginning. The levels become more difficult by the appearance of random obstacles 
which have collision boundaries attached.

## Demo Video

YouTube: https://youtu.be/bm32XMrUeVo

## Extra Features

* Short vibration when ball is shot.
* Short vibration when bird is killed.
* Menu music (looped).
* Sound effects: Bird death, ball shot, game won, game lost.
* Animations: Twinkling stars (on menu screen background), explosion (on bird death)
* Obstacles with collision behaviours, each time the game is played the obstacles generated are a new random size/position.
* Randomly generated obstacles: random size (within a safe range to not restrict the ball to travel to the birds), 
and random position (also within a safe position boundary range).
* Multiple level layouts (3 different levels).
* Credits page pop-up view.
* Replay button at the end of the game.
* Live in-game UI: Score counter, time remaining, current level.
* Landscape-only orientation with autorotate (landscape.left and landscape.right).
* Graphics incuding App icon set for all iPhone models.
* If more than 25 balls exist at once, the oldest ball will be deleted every 2 seconds to free up processing power 
(prevents memory leak).
* Game over/game complete/menu/next level screens.

## Deployment

* iOS Simulator in Xcode - Tested versions were iPhone 8 and iPhone 11.
* Physical iPhone device - Tested versions iPhone 6S, iPhone 8, iPhone X.

## Built With

* [Swift 5.1](https://developer.apple.com/swift/) - Programming language.
* [Xcode 11](https://developer.apple.com/xcode/) - Apple IDE.

## Authors

* **Aston Turner** - *Initial work* - [Aston13](https://github.com/Aston13)

See also the list of [contributors](https://github.com/Aston13/16052488/graphs/contributors) who are involved with this project.

## Acknowledgments

* Xianhui Che (Cherry)
* Barry Ip
