//
//  main.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

@main
struct Main {
    
    private static var gap: TimeInterval {
        0.77
    }
    
    private static func deadline(of index: Int) -> TimeInterval {
        Double(index) * gap
    }
    
    private static func printSes(_ ses: Ses) {
        
        let group = DispatchGroup()
        lazy var now = DispatchTime.now()
                
        for (index, s) in zip(ses.indices, ses) {
            group.enter()
            DispatchQueue.global().asyncAfter(deadline: now + deadline(of: index)) {
                print(s)
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().asyncAfter(deadline: now + deadline(of: ses.endIndex)) {
            group.leave()
        }
        
        group.wait()
        
    }
    
    private static func printSes(with article: Article) async {
        
        return await withCheckedContinuation { continuation in
            
            let ses = Ses(additionalS: article.title)
            DispatchQueue.global().async {
                printSes(ses)
                continuation.resume()
            }
            
        }
        
    }
    
    private static func openArticle(id: Int) {
        
        WikipediaArticleOpener().openArticle(id: id)
        
    }
    
    static func main() async throws {
        
        let article = try await WikipediaRandomArticalRetriever().getArticle(first: { $0.title.hasPrefix("S") })
        await printSes(with: article)
        openArticle(id: article.id)
        
    }
    
}
