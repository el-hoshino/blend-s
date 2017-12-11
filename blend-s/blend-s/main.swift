//
//  main.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

enum Result {
	case success(Article)
	case failure(Error)
}

private func getArticleStartsWithS(completion: ((_ result: Result) -> Void)? = nil) {
	
	WikipediaRandomArticalRetriever().getArticle(first: { $0.title.hasPrefix("S") }) { (result) in
		
		switch result {
		case .success(article: let article):
			completion?(.success(article))
			
		case .failure(error: let error):
			completion?(.failure(error))
		}
		
	}
	
}

private func printSes(with article: Article) {
	
	let ses = Ses(additionalS: article.title)
	
	for s in ses {
		print(s)
		Thread.sleep(forTimeInterval: 0.77)
	}
	
	WikipediaArticleOpener().openArticle(id: article.id)

}

getArticleStartsWithS { result in
	switch result {
	case .success(let article):
		printSes(with: article)
		exit(0)
		
	case .failure(let error):
		print(error)
		exit(1)
	}
}

dispatchMain()
