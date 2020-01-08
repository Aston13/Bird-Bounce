//
//  AudioController.swift
//  Aston-Coursework
//
//  Created by A&M on 06/01/2020.
//  Copyright © 2020 16052488. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var soundPath: String?
var url: URL?
var audioPlayer1: AVAudioPlayer?
var audioPlayer2: AVAudioPlayer?
var audioPlayer3: AVAudioPlayer?

public func playVibrate() {
    AudioServicesPlaySystemSound(1520)
}
public func playSound1(){
    do {
        audioPlayer1 = try AVAudioPlayer(contentsOf: (url)!)
        audioPlayer1?.play()
    } catch {
        print("Sound not found")
    }
}

public func playSound2(){
    do {
        audioPlayer2 = try AVAudioPlayer(contentsOf: (url)!)
        audioPlayer2?.play()
    } catch {
        print("Sound not found")
    }
}

public func playMusic(){
    do {
        audioPlayer3 = try AVAudioPlayer(contentsOf: (url)!)
        audioPlayer3?.play()
        audioPlayer3?.numberOfLoops = -1
    } catch {
        print("Sound not found")
    }
}

public func playDeathSound(){
    soundPath = Bundle.main.path(forResource: "Audio/boing", ofType: "wav")
    url = URL(fileURLWithPath: soundPath!)
    audioPlayer1?.volume = 200
    playSound1()
}

public func playShotSound(){
    soundPath = Bundle.main.path(forResource: "Audio/shot", ofType: "wav")
    url = URL(fileURLWithPath: soundPath!)
    audioPlayer1?.volume = 100
    playSound1()
}

public func playMenuMusic(){
    soundPath = Bundle.main.path(forResource: "Audio/menu", ofType: "wav")
    url = URL(fileURLWithPath: soundPath!)
    playMusic()
}

public func playWinSound(){
    soundPath = Bundle.main.path(forResource: "Audio/win", ofType: "mp3")
    url = URL(fileURLWithPath: soundPath!)
    playSound2()
}

public func playLostSound(){
    soundPath = Bundle.main.path(forResource: "Audio/loss", ofType: "wav")
    url = URL(fileURLWithPath: soundPath!)
    playSound2()
}


