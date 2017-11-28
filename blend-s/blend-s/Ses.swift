//
//  Ses.swift
//  blend-s
//
//  Created by 史 翔新 on 2017/11/28.
//  Copyright © 2017年 史 翔新. All rights reserved.
//

import Foundation

private let pres: [String] = [
    "Smile",
    "Sweet",
    "Sister",
    "Sadistic",
    "Surprise",
    "Service"
]

struct Ses {
    
    fileprivate let ses: [String]
    
}

extension Ses {
    
    init(additionalS: String) {
        let ses = pres + [additionalS]
        self.ses = ses
    }
    
}

extension Ses: Sequence {
    
    func makeIterator() -> Array<String>.Iterator {
        return self.ses.makeIterator()
    }
    
}
