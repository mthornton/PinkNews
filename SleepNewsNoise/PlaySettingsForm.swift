//
//  PlaySettingsForm.swift
//  SleepNewsNoise
//
//  Created by Michael Thornton on 6/6/23.
//

import SwiftUI

struct PlaySettingsForm: View {
    
    let durations = [2, 4, 8, 12]
        
    @StateObject var settings = Settings()
    
    @State var duration = 8
    
    var body: some View {
        Form {
            Section {
                    
                Picker("News feed", selection: $settings.feedName) {
                    ForEach(Settings.feeds, id: \.self) {
                        Text($0).foregroundColor(Color("Primary")).tag($0)
                    }
                }

                Picker("Sound", selection: $settings.soundName) {
                    ForEach(Settings.soundNames, id: \.self) {
                        Text($0).foregroundColor(Color("Primary")).tag($0)
                    }
                }
                
                Picker("Duration", selection: $settings.pinkDuration) {
                    ForEach(durations, id: \.self) { duration in
                        Text("\(duration) hours").tag(duration)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .onAppear {
            print("\(settings)")
        }

    } // end body
    
} // end struct



//struct PlaySettingsForm_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaySettingsForm()
//    }
//}
