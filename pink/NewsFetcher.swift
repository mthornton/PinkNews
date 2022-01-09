//
//  NewsFetcher.swift
//  pink
//
//  Created by Michael Thornton on 1/6/22.
//

import Foundation



class NewsFetcher {
    
    
    func getLatestAudioFromFeed(_ link: String, onCompletion completion: @escaping (URL?)->()) {
        
        
        guard let url = URL(string: link) else {
            print("failed to find URL")
            completion(nil)
            return
        }

        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                print("done")
                
                switch result {
                    case .success(let feed):

                        switch feed {
                            case let .rss(feed):
                                print("rss")
                                if let item = feed.items?.first {
                                    if let u = item.enclosure?.attributes?.url {
                                        //u = u.replacingOccurrences(of: "http://", with: "https://")
                                        completion(URL(string: u))
                                    }
                                }

                            case .atom(_):
                                preconditionFailure("unexpected feed type")
                            case .json(_):
                                preconditionFailure("unexpected feed type")
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    
} // end class
