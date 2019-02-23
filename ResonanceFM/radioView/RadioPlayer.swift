//
//  RadioPlayer.swift
//  Resonance App
//
//  Created by Chanuka Gurusinghe on 8/12/16.
//  Copyright © 2016 Radio Club. All rights reserved.
//

import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()


//stream connectivity model
    private var player = AVPlayer(url: NSURL(string: "http://108.163.197.114:8035/;stream.mp3")! as URL)
    private var isPlaying = false
    
    
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
}
