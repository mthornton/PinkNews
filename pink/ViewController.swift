//
//  ViewController.swift
//  pink
//
//  Created by Michael Thornton on 1/5/22.
//

import UIKit


enum PlayState {
    case waiting
    case playingNews
    case playingPink
}

class ViewController: UIViewController {

    let feedLink = "https://feeds.npr.org/510318/podcast.xml" // npr up first
    //let feedLink = "https://podcasts.files.bbci.co.uk/p02nq0gn.rss" // BBC Global News
    //let feedLink = "http://feeds.feedburner.com/pri/theworld" // The world
    
    let audioPlayerNews = AudioPlayer()
    let audioPlayer = AudioPlayer()
    var state = PlayState.waiting
    
    @IBOutlet weak var stepperNewsLength: UIStepper!
    @IBOutlet weak var stepperPinkLength: UIStepper!
    
    @IBOutlet weak var labelNewsLength: UILabel!
    @IBOutlet weak var labelPinkLength: UILabel!
    
    
    
    override func viewDidLoad() {
        stepperPinkLength.value = 2
        stepperNewsLength.value = 10
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        
        if state == .waiting {
            let newsFetcher = NewsFetcher()
            newsFetcher.getLatestAudioFromFeed(feedLink) { url in
                print("found URL \(url?.absoluteString ?? "")")
                self.playNewsURL(url)
            }
        }
        else {
            state = .waiting
            self.audioPlayer.stop()
            self.audioPlayerNews.stop()
        }
    }
    
    
    @IBAction func stepperNewsChanged(_ sender: UIStepper) {
        
        labelNewsLength.text = "\(Int(stepperNewsLength.value)) mins"
    }
    
    
    @IBAction func stepperPinkChanged(_ sender: UIStepper) {
        
        labelPinkLength.text = "\(Int(stepperPinkLength.value)) hours"
    }

    
    
    private func playNewsURL(_ url: URL?) {
        
        guard let url = url else {
            print("error with new URL")
            return
        }
        
        state = .playingNews
        
        let duration = stepperNewsLength.value * 60
        self.audioPlayerNews.playURL(url, forDuration: duration, forNumberOfLoops: 0) {
            
            self.state = .playingPink
            
            let duration = self.stepperPinkLength.value * 3600
            self.audioPlayer.playMP3File("Pink_noise.ogg.mp3", forDuration: duration, forNumberOfLoops: -1)
        }
    }
    
} // end class

