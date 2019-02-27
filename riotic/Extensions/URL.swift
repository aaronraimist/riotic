//
//  URL.swift
//  riotic
//
//  Created by Aaron Raimist on 2019-02-22.
//  Copyright © 2019 Aaron Raimist. All rights reserved.
//

import Foundation

extension URL {
	var isValidURL: Bool {
		let str = self.absoluteString
		
		let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		if let match = detector.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.endIndex.encodedOffset)) {
			// it is a link, if the match covers the whole string
			return match.range.length == str.endIndex.encodedOffset
		} else {
			return false
		}

	}
}
