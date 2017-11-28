//
//  main.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

private func printSes(with article: Article) {
	
	let ses = Ses(additionalS: article.title)
	
	for s in ses {
		print(s)
		Thread.sleep(forTimeInterval: 0.77)
	}
	
	WikipediaArticleOpener().openArticle(id: article.id)

}

private func getArticleStartsWithS() {
	
	WikipediaRandomArticalRetriever().getArticle(first: { $0.title.hasPrefix("S") }) { (result) in
		
		switch result {
		case .success(article: let article):
			printSes(with: article)
			exit(0)
			
		case .failure(error: let error):
			print(error)
			exit(1)
		}
		
	}
	
}

getArticleStartsWithS()

RunLoop.main.run()
