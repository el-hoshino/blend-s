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
	
	init() {
		
		guard let url = URL(string: retrievingURLString) else {
			fatalError("Preset URL String invalid: \(retrievingURLString)")
		}
		
		self.retrievingURL = url
		
	}
	
}

extension WikipediaRandomArticalRetriever {
	
	func getArticle(first predicate: @escaping (Article) throws -> Bool) async throws -> Article {
		
        let data = try await downloader.downloadData(from: retrievingURL).data
        let article = try getArticle(first: predicate, from: data)
        return article
		
	}
	
	private func getArticle(first predicate: @escaping (Article) throws -> Bool, from data: Data) throws -> Article {
		
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
        guard let article = try wikipediaData.article(first: predicate) else {
            return try self.getArticle(first: predicate, from: data)
        }
        return article
        
	}
    
}

private class Downloader {
    
    private init() {
        
    }
    
    public static let shared = Downloader()
    
    func downloadData(from url: URL) async throws -> (data: Data, response: URLResponse) {
        
        let session = URLSession.shared
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: url) { data, response, error in
                
                switch (data, response, error) {
                case (.some(let data), .some(let response), _):
                    continuation.resume(returning: (data, response))
                    
                case (_, _, .some(let error)):
                    continuation.resume(throwing: error)
                    
                case _:
                    continuation.resume(throwing: NSError(domain: "Unknown", code: 0))
                }
                
            }
            
            task.resume()
            
        }
        
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
