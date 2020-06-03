//
//  Range+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension Range where Bound == String.Index {

    /// Range转NSRange
    var toNSRange: NSRange {
        let low = self.lowerBound
        let lar = self.upperBound
        return NSMakeRange(low.encodedOffset, lar.encodedOffset - low.encodedOffset)

    }
    /// NSRange转Range
//    Range.init(<#T##range: NSRange##NSRange#>, in: <#T##String#>)
    
}

extension String {
    func toNSRange(range: Range<String.Index>) -> NSRange {
        return NSRange.init(range, in: self)
    }
    
    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        return Range<String.Index>.init(nsRange, in: self)
    }
}

