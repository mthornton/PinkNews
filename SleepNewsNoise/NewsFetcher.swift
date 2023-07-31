//
//  NewsFetcher.swift
//  SleepNewsNoise
//
//  Created by Michael Thornton on 6/6/23.
//

import Foundation


class NewsFetcher {
    
    
    func getLatestAudioFromFeed(_ link: String, onCompletion completion: @escaping (URL?, TimeInterval?)->()) {
        
        
        guard let url = URL(string: link) else {
            Logger.shared.log("failed to find URL")
            completion(nil, nil)
            return
        }

        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                
                switch result {
                    case .success(let feed):

                        switch feed {
                            case let .rss(feed):
                                print("rss")
                                if let item = feed.items?.first {
                                    if let u = item.enclosure?.attributes?.url {
                                        if let duration = item.iTunes?.iTunesDuration {
                                            Logger.shared.log("duration = \(duration)")
                                            completion(URL(string: u), duration)
                                        }
                                        else {
                                            completion(URL(string: u), nil)
                                        }
                                    }
                                }

                            case .atom(_):
                                Logger.shared.log("unexpected feed type")
                            case .json(_):
                                Logger.shared.log("unexpected feed type")
                        }
                    case .failure(let error):
                        Logger.shared.log(error.localizedDescription)
                        completion(nil, nil)
                }
            }
        }
    }
    
    
} // end class
