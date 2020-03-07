//
// Created by Артем on 07/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import CoreText

extension NSAttributedString {
    func fittingSize(withSize size: CGSize, numberOfLines: Int) -> CGSize {
        let framesetter = CTFramesetterCreateWithAttributedString(self)
        if numberOfLines == 0 {
            var textSize: CGSize = .zero
            textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(CFIndex(0), CFIndex(0)), nil, size, nil)

            return CGSize(width: textSize.width.rounded(.up), height: textSize.height.rounded(.up))
        } else {
            let path = CGPath(rect: CGRect(x: 0, y: 0, width: size.width, height: CGFloat.greatestFiniteMagnitude), transform: nil)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(CFIndex(0), length), path, nil)

            let lines = CTFrameGetLines(frame) as? [CTLine]
            guard let requiredLines = lines else {
                return .zero
            }
            var len = CFIndex(0)

            for (index, line) in requiredLines.enumerated() {
                if numberOfLines > 0 && index == numberOfLines {
                    break
                }

                let range = CTLineGetStringRange(line)
                len += range.length
            }

            let strRange = CFRangeMake(CFIndex(0), len)
            let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, strRange, nil, size, nil)

            return CGSize(width: textSize.width.rounded(.up), height: textSize.height.rounded(.up))
        }
    }
}