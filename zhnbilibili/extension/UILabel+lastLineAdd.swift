//
//  UILabel+lastLineAdd.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/1.
//  Copyright © 2017年 zhn. All rights reserved.
//

import CoreText

extension UILabel {
    
    var firstLineString: String {
        
        guard let text = self.text else { return "" }
        guard let font = self.font else { return "" }
        let rect = self.frame
        
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(String(kCTFontAttributeName), value: CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil), range: NSMakeRange(0, attStr.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width + 7, height: 100))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        guard let line = (CTFrameGetLines(frame) as! [CTLine]).first else { return "" }
        let lineString = text[text.startIndex...text.index(text.startIndex, offsetBy: CTLineGetStringRange(line).length-2)]
        
        return lineString
    }
    
    
    func getLinesArrayOfStringInLabel() -> [String] {
        
        let text = self.text! as NSString
        let font:UIFont = self.font
        let rect:CGRect = self.frame
        
        
        let myFont:CTFont = CTFontCreateWithName(font.fontName as CFString?, font.pointSize, nil)
        let attStr:NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attStr.addAttribute(String(kCTFontAttributeName), value:myFont, range: NSMakeRange(0, attStr.length))
        let frameSetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path:CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 1000000))
        let frame:CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as NSArray
        var linesArray = [String]()
        
        for line in lines {
            let lineRange = CTLineGetStringRange(line as! CTLine)
            let range:NSRange = NSMakeRange(lineRange.location, lineRange.length)
            let lineString = text.substring(with: range)
            linesArray.append(lineString as String)
        }
        return linesArray
    }
}
