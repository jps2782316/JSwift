//
//  FoldView.swift
//  JSwift
//
//  Created by jps on 2021/5/17.
//

import UIKit
/*
 CoreText实战讲解，手把手教你实现图文、点击高亮、自定义截断功能
 https://juejin.cn/post/6960854099784892430
 */
class FoldView: UIView {

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1, y: -1)
        
        let s = "我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本我是一个富文本"
        let attributeStr = NSMutableAttributedString(string: s)
        attributeStr.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.red], range: NSMakeRange(0, s.count - 1))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributeStr as CFAttributedString)
        let path = CGMutablePath()
        path.addRect(bounds)
        let lenth = attributeStr.length
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, lenth), path, nil)
        
        let lines = CTFrameGetLines(frame)
        let lineCount: CFIndex = CFArrayGetCount(lines)
        var origins = [CGPoint](repeating: .zero, count: lineCount)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        //限制展示1行
        let numberOfLines = 2
        var count = numberOfLines == 0 ? lineCount : numberOfLines
        if count > lineCount { count = lineCount }
        //判断是否需要展示截断符，小于总行数都需要展示截断符
        let needsShowTruncation = count < lineCount
        
        let linesArr = lines as Array
        for i in 0..<count {
            //Cannot convert value of type 'UnsafeRawPointer?' to expected argument type 'CTLine'
            //let line = CFArrayGetValueAtIndex(lines, i) as! CTLine //会崩
            let line = linesArr[i] as! CTLine
            let range = CTLineGetStringRange(line)
            let origin = origins[i]
            //一旦我们通过CTLineDraw绘制文字后，那么需要我们自己来设置行的位置，否则都位于最底下显示
            context.textPosition = CGPoint(x: origin.x, y: origin.y)
            
            if i == count - 1 && needsShowTruncation {
                let drawLineString = NSMutableAttributedString(attributedString: attributeStr.attributedSubstring(from: NSMakeRange(range.location, range.length)))
                let truncationTokenText = NSAttributedString(string: "点我展开", attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.brown])
                //这两行可以控制截断符的位置是在开头、中间，还是结尾
                let type: CTLineTruncationType = .end
                drawLineString.append(truncationTokenText)
                
                let drawLine = CTLineCreateWithAttributedString(drawLineString as CFAttributedString)
                let tokenLine = CTLineCreateWithAttributedString(truncationTokenText as CFAttributedString)
                //创建带有截断的行
                if let truncationLine = CTLineCreateTruncatedLine(drawLine, Double(rect.size.width), type, tokenLine) {
                    CTLineDraw(truncationLine, context) //绘制
                }
            }else {
                CTLineDraw(line, context)
            }
        }
    }

}
