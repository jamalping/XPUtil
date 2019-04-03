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
    public var toNSRange: NSRange {
        let loc = self.lowerBound
        let length = self.upperBound
        return NSMakeRange(loc.encodedOffset, length.encodedOffset - loc.encodedOffset)
        
    }
    /// NSRange转Range
    /// Range.init(<#T##range: NSRange##NSRange#>, in: <#T##String#>)
}


