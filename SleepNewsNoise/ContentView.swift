//
//  ContentView.swift
//  SleepNewsNoise
//
//  Created by Michael Thornton on 11/7/22.
//

import SwiftUI

enum PlayState {
    case waiting
    case playingNews
    case playingPink
}


struct ContentView: View {
    
    @State private var playState: PlayState = .waiting
    @State private var shouldShowForm = false
    
    @State private var audioPlayer: AudioPlayer?
    
    @State private var isLoading = false
    
    @State private var statusMessage = ""
    
    @State private var timer: Timer?
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                
                HStack {
                    Spacer()
                    Button {
                        shouldShowForm = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .tint(Color("AccentColor"))
                    }
                    .padding()
                }
                
                Button {
                    togglePlay()
                } label: {
                    Image(systemName: (playState == .waiting) ? "play.circle" : "pause.circle")
                        .font(.system(size: 128.0))
                        .padding(16)
                        .tint(Color("Primary"))
                }
                Text(statusMessage)
                    .padding()
                Spacer()
            }
            .sheet(isPresented: $shouldShowForm) {
                PlaySettingsForm()
                    .scrollContentBackground(.hidden)
            }
            
            Spacer()
        }
        .background(Color("Background"))
    } // end body
    
    
    func togglePlay() {
        if playState == .waiting {
            
            let settings = Settings()
            
            if let link = settings.link {
                let newsFetcher = NewsFetcher()
                
                statusMessage = "Fetching podcast info."
                
                newsFetcher.getLatestAudioFromFeed(link) { url, duration in
                    statusMessage = "Playing podcast."
                    playNewsURL(url, withEpisodeDuration: duration)
                    
                    // turn off the status message in 10 seconds
                    timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { timer in
                        self.timer = nil
                        statusMessage = ""
                    })
                    
                }
            }
            else {
                playPinkNoise()
            }
        }
        else {
            stopPinkNoise()
        }
    }
    
    
    func playPinkNoise() {
        playState = .playingPink
        
        let settings = Settings()
        
        self.audioPlayer = AudioPlayer()
        
        audioPlayer!.playMP3File(settings.soundFileName, forDuration: Double(settings.pinkDuration * 60 * 60), forNumberOfLoops: -1)
    }
    
    
    
    func stopPinkNoise() {
        playState = .waiting
        
        audioPlayer?.stop()
    }
    
    
    private func playNewsURL(_ url: URL?, withEpisodeDuration episodeDuration: Double?) {
        
        guard let url = url else {
            Logger.shared.log("error with new URL")
            playPinkNoise()
            return
        }
                
        guard let duration = episodeDuration else {
            Logger.shared.log("no duration")
            playPinkNoise()
            return
        }
        
        playState = .playingNews
        
        self.audioPlayer = AudioPlayer()
        

        print("got duration \(duration) but changing to 10")

        audioPlayer!.playURL(url, forDuration: duration , forNumberOfLoops: 0) {
            self.audioPlayer = nil
            playPinkNoise()
        }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
