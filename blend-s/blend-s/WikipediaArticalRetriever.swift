//
//  WikipediaArticalRetriever.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

class WikipediaRandomArticalRetriever {
    
    private let downloader = Downloader.shared
    
    private let retrievingURL = URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&list=random&rnnamespace=0&rnlimit=max")
    
}

private class Downloader {
    
    public enum Result {
        
        public enum Error: Swift.Error {
            case taskError(Swift.Error)
            case contentError(Swift.Error)
            case invalidURL(url: URL)
        }
        
        case success(data: Data, response: URLResponse)
        case failure(error: Error)
        
    }
    
    private init() {
        
    }
    
    public static let shared = Downloader()
    
    open func downloadData(from url: URL, completionHandler: @escaping (_ result: Result) -> Void) {
        
        let session = URLSession.shared
        let task = session.downloadTask(with: url, completionHandler: { (localURL, response, error) in
            
            guard let localURL = localURL, let response = response else {
                if let error = error {
                    completionHandler(.failure(error: .taskError(error)))
                } else {
                    completionHandler(.failure(error: .invalidURL(url: url)))
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                completionHandler(.success(data: data, response: response))
                
            } catch let error {
                completionHandler(.failure(error: .contentError(error)))
                
            }
            
        })
        
        task.resume()
        
    }
    
}
