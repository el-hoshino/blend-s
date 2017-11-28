//
//  WikipediaArticleOpener.swift
//  blend-s
//
//  Created by 史翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Cocoa

private let openingURLString = "http://en.wikipedia.org"

class WikipediaArticleOpener {
	
	private let openingURL: URL
	
	init() {
		
		guard let url = URL(string: openingURLString) else {
			fatalError("Preset URL String invalid: \(openingURLString)")
		}
		
		self.openingURL = url
		
	}
	
	func openArticle(id: Int) {
		
		let idQueryItem = URLQueryItem(name: "curid", value: id.description)
		let openingURL = self.openingURL.appendingQueryItem(idQueryItem)
		
		NSWorkspace.shared.open(openingURL)
		
	}
	
}

private extension URL {
	
	func appendingQueryItem(_ item: URLQueryItem) -> URL {
		
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
			assertionFailure("Failed to make URLComponents from URL: \(self)")
			return self
		}
		
		components.append(item)
		
		guard let url = components.url else {
			assertionFailure("Failed to add URLQueryItem URL to URL: \(self)")
			return self
		}
		
		return url
		
	}
	
}

private extension URLComponents {
	
	mutating func append(_ item: URLQueryItem) {
		
		var queryItems = self.queryItems ?? []
		queryItems.append(item)
		self.queryItems = queryItems
		
	}
	
}
