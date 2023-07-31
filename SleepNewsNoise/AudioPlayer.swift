//
//  AudioPlayer.swift
//  pink
//
//  Created by Michael Thornton on 1/6/22.
//

import Foundation
import AVFoundation


class AudioPlayer {
    
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var timerFade: Timer?
    private var timerIn: Timer?
        
    typealias onStopClosure = ()->Void
    private var onStop: onStopClosure?
    
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    
    private func prepPlayerForForLoops(_ loops: Int) {
                
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.volume = 1.0
        self.audioPlayer?.numberOfLoops = loops
        self.audioPlayer?.play()
    }
    
    

    func stop() {
        self.audioPlayer?.stop()
        self.audioPlayer?.volume = 1.0
        self.audioPlayer = nil
        self.timer = nil
    }
    
    
    
    func playURL(_ url: URL, forDuration duration: TimeInterval, forNumberOfLoops loops: Int, onCompletion completion: @escaping ()->Void) {

        //DispatchQueue.global().async {
            
            do {
                
                self.onStop = completion
                
                let data = try Data(contentsOf: url)
                self.audioPlayer = try AVAudioPlayer(data: data)
                
                self.prepPlayerForForLoops(loops)

                self.timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { (timer) in
                    // self.fadeAudioOut()
                    print("audio finished")
                    completion()
                })
                
//                self.fadeAudioIn()
            }
            catch {
                print("problem playing audio : \(error.localizedDescription)")
                completion()
            }
        //}
    }

    
    
    func playMP3File(_ fileName: String, forDuration duration: TimeInterval, forNumberOfLoops loops: Int) {

        guard let path = Bundle.main.resourcePath else {
            print("failed to get resource path")
            return
        }

        let url = URL.init(fileURLWithPath: "\(path)/\(fileName)")
        
        do {
            
            self.audioPlayer = try AVAudioPlayer.init(contentsOf: url, fileTypeHint: "mp3")
            
            prepPlayerForForLoops(loops)
            
//            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { (timer) in
//                print("fade start")
//                self.fadeAudioOut()
//            })
            
            
            //self.fadeAudioIn()
            
        }
        catch {
            print("problem playing audio")
        }
    }
    

    
//    @objc func fadeAudioIn() {
//
//        if let p = self.audioPlayer {
//
//            print("fade \(p.volume)")
//
//            let stepSize: Float = 0.03
//
//            if p.volume < 1.0 {
//
//                if p.volume + stepSize < 1.0 {
//                    p.volume += stepSize
//                }
//                else {
//                    p.volume = 1.0
//                }
//
//                print("fade up \(p.volume)")
//
//                self.timerFade = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
//                    self.fadeAudioIn()
//                })
//            }
//        }
//    }
//
//    @objc func fadeAudioOut() {
//
//        if let p = self.audioPlayer {
//            print("fade out \(p.volume)")
//            if p.volume <= 0.1 {
//                p.stop()
//                if let onStop = self.onStop {
//                    onStop()
//                }
//            }
//            else {
//                p.volume -= 0.2
//
//                self.timerFade = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
//                    self.fadeAudioOut()
//                })
//            }
//        }
//    }
    
} // end class

