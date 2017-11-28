//
//  WikipediaArticalRetriever.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

private let retrievingURLString = "https://en.wikipedia.org/w/api.php?format=json&action=query&list=random&rnnamespace=0&rnlimit=max"

class WikipediaRandomArticalRetriever {
    
    private let downloader = Downloader.shared
	
	private let retrievingURL: URL
	
	enum DownloadResult {
		case success(article: Article)
		case failure(error: Swift.Error)
	}
	
	init() {
		
		guard let url = URL(string: retrievingURLString) else {
			fatalError("Preset URL String invalid: \(retrievingURLString)")
		}
		
		self.retrievingURL = url
		
	}
	
}

extension WikipediaRandomArticalRetriever {
	
	func getArticle(first predicate: @escaping (Article) throws -> Bool, completion: @escaping (DownloadResult) -> Void) {
		
		self.downloader.downloadData(from: self.retrievingURL) { (result) in
			
			switch result {
			case .success(data: let data, response: _):
				self.getArticle(first: predicate, from: data, completion: completion)
				
			case .failure(error: let error):
				completion(.failure(error: error))
			}
			
		}
		
	}
	
	private func getArticle(first predicate: @escaping (Article) throws -> Bool, from data: Data, completion: @escaping (DownloadResult) -> Void) {
		
		do {
			let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
			guard let article = try wikipediaData.article(first: predicate) else {
				self.getArticle(first: predicate, completion: completion)
				return
			}
			
			completion(.success(article: article))
			
		} catch let error {
			completion(.failure(error: error))
		}
		
	}
    
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

private struct WikipediaData: Decodable {
	
	let query: Query
	
}

private struct Query: Decodable {
	
	let random: [Article]
	
}

struct Article: Decodable {
	let id: Int
	let title: String
}

extension WikipediaData {
	
	func article(first predicate: (Article) throws -> Bool) rethrows -> Article? {
		
		let article = try self.query.random.first(where: predicate)
		return article
		
	}
	
}
