//
//  FoldLabel.swift
//  JSwift
//
//  Created by jps on 2021/5/13.
//

import UIKit

/*
 iOS 可显示全部、收起（折叠、展开）的label
 https://www.jianshu.com/p/72fb226fac4f
 
 DYFoldLabel -- 一行代码实现折叠label
 https://juejin.cn/post/6844903780161601544
 
 ios 超过一定行数的label强制在末尾加上一个...展开且可以点击成全文
 https://segmentfault.com/q/1010000004452279
 */

class FoldLabel: UILabel {

    
//    override func drawText(in rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
//        //将当前context的坐标系进行flip,否则上下颠倒
//        let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: bounds.size.height)
//        context.concatenate(flip)
//        //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
//        context.textMatrix = .identity
//        let str = "fewfwe"
//        let range = NSMakeRange(0, str.count)
//
//    }
    
    var model: Fold = Fold()
    
    typealias FoldPackupClick = ((_ isFold: Bool, _ currentHeight: CGFloat) -> Void)
    var clicked: FoldPackupClick?
    
    func setFoldText(_ text: String?, width: CGFloat, clicked: FoldPackupClick?) {
        isUserInteractionEnabled = true
        self.text = text
        //self.layoutIfNeeded()
        self.sizeToFit()
        
        guard let text = text, !text.isEmpty else { return }
        
        if let attr = model.foldAttributeText, attr.length > 0 {
            setLabel(isFold: model.isFolded)
            return
        }
        var attrText = NSMutableAttributedString(string: self.text ?? "", attributes: [NSMutableAttributedString.Key.font: self.font!])
        if let str = model.packupText {
            let packup_attr = NSAttributedString(string: str, attributes: [NSMutableAttributedString.Key.font: self.font!, NSMutableAttributedString.Key.foregroundColor: model.packupTextColor ?? self.textColor!])
            attrText.append(packup_attr)
        }
        
        model.attributeText = attrText
        model.text = attrText.string
        model.textFont = self.font
        model.numberOfLines = self.numberOfLines
        model.labelSize = CGSize(width: width, height: bounds.size.height)
        self.clicked = clicked
        
        let fold_attr = NSAttributedString(string: model.foldText!, attributes: [NSMutableAttributedString.Key.font: model.foldFont!, NSMutableAttributedString.Key.foregroundColor: model.foldTextColor ?? self.textColor!])
        
        let frame = ctFrame(attrString: attrText, size: CGSize(width: width, height: bounds.height))
        
        let lines = CTFrameGetLines(frame)
        let index: CFIndex = CFArrayGetCount(lines)
        if index == 0 { return }
        
        //计算第几行结束,折叠文字字体大于文本字体会占用多行
        let endLineIndex = lineReplace(lineCount: index, lines: lines, fontDiff: model.foldFont!.pointSize - self.font.pointSize)
        model.endLineIndex = endLineIndex
        
        //let line = CFArrayGetValueAtIndex(lines, endLineIndex) as! CTLine
        let line = (lines as Array)[endLineIndex] as! CTLine
        let lineRange = CTLineGetStringRange(line)
        let trimRange = NSMakeRange(0, lineRange.location + lineRange.length)
        if trimRange.length < self.text?.count ?? 0 {
            //获取当前能显示的文字
            attrText = attrText.attributedSubstring(from: trimRange).mutableCopy() as! NSMutableAttributedString
            if attrText.string.hasSuffix("\n\n") {
                attrText = attrText.attributedSubstring(from: NSMakeRange(0, lineRange.location + lineRange.length - 1)) as! NSMutableAttributedString
                attrText.append(NSAttributedString(string: "… "))
                attrText.append(fold_attr)
            }else {
                //取需要替换的文字长度
                let str = String(format: "… %@", model.foldText!)
                let length = subLenthWith(attrStr: attrText, lineRange: trimRange, text: str, textFont: model.foldFont!)
                //省略号前需要添加的文字
                attrText = attrText.attributedSubstring(from: NSMakeRange(0, lineRange.location + lineRange.length - length)) as! NSMutableAttributedString
                attrText.append(NSAttributedString(string: "… "))
                attrText.append(fold_attr)
            }
            self.attributedText = attrText
            self.sizeToFit()
            model.foldAttributeText = attrText
        }
        
        let foldFrame = ctFrame(attrString: attrText, size: CGSize(width: width, height: bounds.size.height))
        model.foldFrame = foldFrame
        
        let packupFrame = ctFrame(attrString: model.attributeText!, size: CGSize(width: width, height: model.textHeight))
        model.packupFrame = packupFrame
        
        let packupLines = CTFrameGetLines(packupFrame)
        let packupLineCount = CFArrayGetCount(packupLines)
        if packupLineCount == 0 { return }
        model.lineCount = packupLineCount
        
        layoutIfNeeded()
    }
    
    
    func setLabel(isFold: Bool) {
        if isFold {
            //已展开，显示全部
            self.numberOfLines = 0
            self.attributedText = model.attributeText
        }else {
            self.numberOfLines = model.numberOfLines
            self.attributedText = model.foldAttributeText
        }
    }
    
    
    private func ctFrame(attrString: NSAttributedString, size: CGSize) -> CTFrame {
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let path = CGMutablePath()
        //指定每行的宽度,计算共多少行
        path.addRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        return frame
    }
    
    //因为替换文字大小问题，需要计算第几行结束
    private func lineReplace(lineCount: CFIndex, lines: CFArray, fontDiff: CGFloat) -> Int {
        //计算单行高度
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        //let line: CTLine = CFArrayGetValueAtIndex(lines, 0) as! CTLine
        let line = (lines as Array).first as! CTLine
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
        let lineHeight = ascent + abs(descent) + leading
        
        var lineIndex = 0, index = 0
        let number = numberOfLines - 1
        var totalLineHeight: CGFloat = 0
        while totalLineHeight < (lineHeight + fontDiff) && lineCount > index {
            index += 1
            totalLineHeight = lineHeight * CGFloat(index)
        }
        lineIndex = lineCount - index //这里需要+1，因为最后一行没计算在内，又因为数组最后一个元素索引=count-1,所以+1抵消
        lineIndex = self.numberOfLines > 0 ? min(lineIndex, number) : lineCount - 1
        return lineIndex
    }
    
    //计算被替换的文字长度
    private func subLenthWith(attrStr: NSMutableAttributedString, lineRange: NSRange, text: String, textFont: UIFont) -> Int {
        //折叠按钮文字宽度
        let foldWidth = FoldLabel.sizeFor(text: text, font: textFont, size: CGSize(width: model.labelSize.width, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).width
        var spaceTextWidth: CGFloat = 0
        var index = 0
        while spaceTextWidth < foldWidth {
            let range = NSMakeRange(lineRange.location + lineRange.length - index, index)
            let spaceText = attrStr.attributedSubstring(from: range).string
            spaceTextWidth = FoldLabel.sizeFor(text: spaceText, font: self.font!, size: CGSize(width: model.labelSize.width, height: .greatestFiniteMagnitude), lineBreakMode: .byWordWrapping).width
            index += 1
        }
        return index
    }
    
    
    /// 计算文字尺寸
    /// - Parameters:
    ///   - text: 文字
    ///   - font: 字体
    ///   - size: 文字的最大尺寸
    ///   - lineBreakMode:
    /// - Returns:
    class func sizeFor(text: String, font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        var options: [NSAttributedString.Key: Any] = [.font: font]
        if lineBreakMode != .byWordWrapping {
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = lineBreakMode
            options.updateValue(style, forKey: .paragraphStyle)
        }
        let attrStr = NSAttributedString(string: text, attributes: options)
        let rect = attrStr.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        //(text as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: options, context: nil)
        return rect.size
    }
}


extension FoldLabel {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let clickPoint = CGPoint(x: location.x, y: bounds.size.height - location.y)
        let frame: CTFrame
        let endLineIndex: CFIndex
        let font: UIFont
        if model.isFolded {
            frame = model.packupFrame!
            endLineIndex = model.lineCount - 1
            font = model.packupFont!
        }else {
            frame = model.foldFrame!
            endLineIndex = model.endLineIndex!
            font = model.foldFont!
        }
        
        //获取最后一行
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        if lineCount == 0 { return }
        
        //获取行上行、下行、间距
        var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
        //let endLine = CFArrayGetValueAtIndex(lines, endLineIndex) as! CTLine
        let endLine = (lines as Array)[endLineIndex] as! CTLine
        CTLineGetTypographicBounds(endLine, &ascent, &descent, &leading)
        
        let endLineHeight = leading + max(font.pointSize, self.font.pointSize)
        //计算点击位置是否在折叠行内
        var origins = [CGPoint](repeating: .zero, count: lineCount) //用于存储每一行的坐标
        
        
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        let endLineOrigin = origins[endLineIndex]
        
        let textHeight = bounds.size.height - endLineOrigin.y + endLineHeight
        if clickPoint.y <= (bounds.size.height * 0.5 - textHeight * 0.5 + endLineHeight + 5) && clickPoint.y >= (bounds.size.height * 0.5 - textHeight * 0.5) {
            let index = CTLineGetStringIndexForPosition(endLine, clickPoint)
            let foldText = model.foldText ?? ""
            let offset = self.text?.count ?? 0 > 2 ? 2 : 0
            let range = NSMakeRange(self.text?.count ?? 0 - foldText.count - offset, foldText.count + offset)
            //判断点击的字符是否在需要处理点击事件的字符串范围内
            if range.location <= index {
                model.isFolded = !model.isFolded
                setLabel(isFold: model.isFolded)
                if model.isFolded {
                    clicked?(model.isFolded, model.textHeight)
                }else {
                    clicked?(model.isFolded, model.foldHeight)
                }
            }
        }
    }
    
    
}
