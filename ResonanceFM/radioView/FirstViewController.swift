//
//  FirstViewController.swift
//  Resonance App
//
//  Created by Chanuka Gurusinghe on 8/12/16.
//  Copyright © 2016 Radio Club. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

var disclaimerDisplayed = false
class FirstViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if disclaimerDisplayed == false{
            disclaimerDisplayed = true
        let defaults = UserDefaults.standard
        if(!defaults.bool(forKey: "alertOnce")){

            
            let alert = UIAlertController(title: "Greetings", message: "Please make sure that you are connected with the internet", preferredStyle: UIAlertControllerStyle.alert)
            let dontShow = UIAlertAction(title: "Do not show again", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                
                defaults.set(true, forKey: "alertOnce")
                defaults.synchronize()
            }
            
            let cancelAct = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
                alert.removeFromParentViewController()
            }
            alert.addAction(cancelAct)
            alert.addAction(dontShow)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  // MPAudioPlayback on the Lockscreen
        if NSClassFromString("MPNowPlayingInfoCenter") != nil {
         let image:UIImage = UIImage(named: "IMG_0010.png")!
         let albumart = MPMediaItemArtwork(image: image)
            let songInfo = [
                MPMediaItemPropertyTitle: "Resonance Radio",
                MPMediaItemPropertyArtist: "90.1fm",
                MPMediaItemPropertyArtwork: albumart
            ] as [String : Any]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
        
        do {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            
            print("Receiving remote control events\n")
        } catch {
            print("Audio Session error.\n")
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            print("no event\n")
            return
        }
        guard event.type == .remoteControl else {
            print("received other event type\n")
            return
        }
        switch event.subtype {
        case .remoteControlPlay:
            print("received remote play\n")
            RadioPlayer.sharedInstance.play()
        case .remoteControlPause:
            print("received remote pause\n")
            RadioPlayer.sharedInstance.pause()
        case .remoteControlTogglePlayPause:
            print("received toggle\n")
            RadioPlayer.sharedInstance.toggle()
        default:
            print("received \(event.subtype) which we did not process\n")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//AudioplayBtn = toggle
    
    @IBOutlet weak var btnPress: UIButton!
    @IBAction func playButtonPressed(_ sender: UIButton) {
        toggle()
    }
    
    func toggle() {
       if RadioPlayer.sharedInstance.currentlyPlaying() {
        
            pauseRadio()
            //playButton.setImage(UIImage(named:"Play Filled-50.png"),for:UIControlState.normal)
            
        } else {
            playRadio()
            //playButton.setImage(UIImage(named:"Stop Filled-50.png"),for:UIControlState.normal)
        }
        
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        btnPress.setImage(UIImage(named: "btn-pause.png"), for: .normal)
        
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        btnPress.setImage(UIImage(named: "btn-play.png"), for: .normal)
        
    }
    @IBAction func share(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["https://itunes.apple.com/app/resonance-radio/id1143945520?mt=8"], applicationActivities: nil)
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            activityController.popoverPresentationController?.sourceView = self.view
            activityController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            activityController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
        }
        self.present(activityController, animated: true,completion: nil)
    }


}








