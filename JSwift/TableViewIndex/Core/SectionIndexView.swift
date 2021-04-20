//
//  SectionIndexView.swift
//  JSwift
//
//  Created by jps on 2021/4/20.
//

import UIKit

class JTextLayer: CATextLayer {
    
    var itemFont: UIFont!
    
    override func draw(in ctx: CGContext) {
        let h = bounds.size.height
        let fontSize = itemFont.lineHeight
        let offsetY = (h - fontSize) / 2.0
        
        ctx.saveGState()
        ctx.translateBy(x: 0, y: offsetY)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
    func set(itemFont: UIFont) {
        self.itemFont = itemFont
        //self.font = itemFont.fontName as CFTypeRef
        self.font = CGFont(itemFont.fontName as CFString)
        self.fontSize = itemFont.pointSize
    }
    
}

protocol SectionIndexViewDelegate: class {
    ///点击/滑动索引时，会触发这个方法
    func sectionIndexView(_ indexView: SectionIndexView, didSelectSectionAt section: Int)
    ///
    func sectionOfIndexView(_ indexView: SectionIndexView, tableViewDidScroll tableView: UITableView) -> Int
}



class SectionIndexView: UIControl {
    
    weak var delegate: SectionIndexViewDelegate?
    
    // 索引视图数据源
    var indexs: [String] = [] {
        didSet {
            configSubLayersAndSubviews()
            configCurrentSection()
        }
    }
    // 当前索引位置
    var currentSection: Int = 0 {
        didSet {
            if (currentSection < 0 && currentSection != kSearchSection) || currentSection >= subTextLayers.count {
                refreshTextLayer(isSelected: false)
                return
            }else {
                refreshTextLayer(isSelected: false)
                //_currentSection = currentSection;
                refreshTextLayer(isSelected: true)
            }
        }
    }
    
    // tableView在NavigationBar上是否半透明
    var translucentForTableViewInNavigationBar: Bool = false
    
    ///tableView从第几个section开始使用索引 Default = 0
    var startSection: Int = 0 {
        didSet { configCurrentSection() }
    }
    ///索引配置
    var config: SectionIndexConfig = SectionIndexConfig(indexItem: .defualt, indicator: .defualt)
    
    
    private var searchLayer: CAShapeLayer!
    private var subTextLayers: [JTextLayer] = []
    private var indicator: UILabel?
    
    weak var tableView: UITableView!
    
    // 触摸索引视图
    private var isTouchingIndexView: Bool = false
    
    // 触感反馈
    private lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    
    init(config: SectionIndexConfig, tableView: UITableView) {
        super.init(frame: .zero)
        self.config = config
        self.tableView = tableView
        if let indicatorConfig = config.indicator {
            indicator = getIndicatorView(indicator: indicatorConfig)
            self.addSubview(indicator!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 根据section值获取TextLayer的中心点y值
    func getTextLayerCenterY(position: CGFloat, margin: CGFloat, spacing: CGFloat) -> CGFloat {
        return margin + (position + 1.0 / 2) * spacing
    }
    // 根据y值获取TextLayer的section值
    func getPositionOfTextLayerInY(y: CGFloat, margin: CGFloat, spacing: CGFloat) -> Int {
        let position = (y - margin) / spacing - 1 / 2.0
        if position <= 0 { return 0 }
        
        let bigger = ceil(position) //向上取整
        let smaller = bigger - 1
        let biggerCenterY = getTextLayerCenterY(position: bigger, margin: margin, spacing: spacing)
        let smallerCenterY = getTextLayerCenterY(position: smaller, margin: margin, spacing: spacing)
        let final = (biggerCenterY + smallerCenterY > 2 * y) ? smaller : bigger
        return Int(final)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let indexItem = config.indexItem
        let space = indexItem.height + indexItem.spacing
        let margin = (bounds.size.height - space * CGFloat(indexs.count)) / 2.0
        
        if let searchLayer = self.searchLayer, !searchLayer.isHidden {
            let x = bounds.size.width - indexItem.rightMargin - indexItem.height
            let y = getTextLayerCenterY(position: 0, margin: margin, spacing: space) - indexItem.height / 2.0
            searchLayer.frame = CGRect(x: x, y: y, width: indexItem.height, height: indexItem.height)
            searchLayer.cornerRadius = indexItem.height / 2.0
            searchLayer.contentsScale = UIScreen.main.scale
            searchLayer.backgroundColor = indexItem.bgColor.cgColor
        }
        
        let deta = (searchLayer == nil) ? 1 : 0
        for (i, textLayer) in subTextLayers.enumerated() {
            let section = i + deta
            let x = bounds.size.width - indexItem.rightMargin - indexItem.height
            let y = getTextLayerCenterY(position: CGFloat(section), margin: margin, spacing: space) - indexItem.height / 2.0
            textLayer.frame = CGRect(x: x, y: y, width: indexItem.height, height: indexItem.height)
        }
        
        CATransaction.commit()
    }
    
    
    func refreshCurrentSection() {
        self.onActionWithScroll()
    }
    
    
    func configSubLayersAndSubviews() {
        let hasSearch = indexs.first == UITableView.indexSearch
        var deta = 0
        if hasSearch {
            if (searchLayer == nil) {
                searchLayer = createSearchLayer(indexItem: config.indexItem)
                self.layer.addSublayer(searchLayer!)
            }
            searchLayer.isHidden = false
            deta = 1
        }else if (searchLayer != nil) {
            searchLayer.isHidden = true
        }
        
        let countDifference = indexs.count - deta - subTextLayers.count
        if countDifference > 0 {
            for _ in 0..<countDifference {
                let textLayer = JTextLayer()
                self.layer.addSublayer(textLayer)
                subTextLayers.append(textLayer)
            }
        }else {
            for _ in 0..<(-countDifference) {
                let textLayer = subTextLayers.last
                textLayer?.removeFromSuperlayer()
                subTextLayers.removeLast()
            }
        }
        
        let indexItem = config.indexItem
        let space = indexItem.height + indexItem.spacing
        let margin = (bounds.size.height - space * CGFloat(indexs.count)) / 2
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if hasSearch {
            let x = bounds.size.width - indexItem.rightMargin - indexItem.height
            let y = getTextLayerCenterY(position: 0, margin: margin, spacing: space) - indexItem.height / 2
            searchLayer.frame = CGRect(x: x, y: y, width: indexItem.height, height: indexItem.height)
            searchLayer.cornerRadius = indexItem.height / 2
            searchLayer.contentsScale = UIScreen.main.scale
            searchLayer.backgroundColor = indexItem.bgColor.cgColor
        }
        
        for (i, textLayer) in subTextLayers.enumerated() {
            let section = i + deta
            let x = bounds.size.width - indexItem.rightMargin - indexItem.height
            let y = getTextLayerCenterY(position: CGFloat(section), margin: margin, spacing: space) - indexItem.height / 2
            textLayer.frame = CGRect(x: x, y: y, width: indexItem.height, height: indexItem.height)
            textLayer.string = indexs[section]
            textLayer.itemFont = indexItem.textFont
            textLayer.cornerRadius = indexItem.height / 2.0
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.backgroundColor = indexItem.bgColor.cgColor
            textLayer.foregroundColor = indexItem.textColor.cgColor
        }
        
        CATransaction.commit()
        
        if subTextLayers.count == 0 {
            currentSection = Int.max
        }else if currentSection == Int.max {
            currentSection = (searchLayer == nil) ? 0 : kSearchSection
        }else {
            currentSection = subTextLayers.count - 1
        }
        
    }
    
    
    
    
    
    
    let kInvalidSection = Int.max
    let kSearchSection = -1
    
    func configCurrentSection() {
        var currentSection = kInvalidSection
        if let number = delegate?.sectionOfIndexView(self, tableViewDidScroll: self.tableView) {
            currentSection = number
            if (currentSection >= 0 && currentSection != kInvalidSection) || currentSection == kSearchSection {
                self.currentSection = currentSection
                return
            }
        }
        let firstVisibleSection = (self.tableView.indexPathsForVisibleRows?.first?.section)!
        
        let insetTop = kIndexViewInsetTop
        for section in firstVisibleSection..<tableView.numberOfSections {
            let sectionFrame = tableView.rect(forSection: section)
            if sectionFrame.origin.y + sectionFrame.size.height - tableView.contentOffset.y > insetTop {
                currentSection = section
                break
            }
        }
        
        var isSelectSearchLayer = false
        if currentSection == 0 && (searchLayer != nil) && currentSection < tableView.numberOfSections {
            let sectionFrame = tableView.rect(forSection: currentSection)
            isSelectSearchLayer = (sectionFrame.origin.y - tableView.contentOffset.y - insetTop) > 0
        }
        if isSelectSearchLayer {
            currentSection = kSearchSection
        }else {
            currentSection = currentSection - startSection
        }
        self.currentSection = currentSection
    }
    
    
    
    //MARK: --------------------- Event Response ---------------------
    
    
    func onActionWithDidSelect() {
        if (currentSection < 0 && currentSection != kSearchSection) || currentSection >= subTextLayers.count {
            return
        }
        
        let insetTop = kIndexViewInsetTop
        if currentSection == kSearchSection {
            tableView.setContentOffset(CGPoint(x: 0, y: -insetTop), animated: false)
        }else {
            let currentSection = self.currentSection + startSection
            if currentSection >= 0 && currentSection < tableView.numberOfSections {
                let rowCountInSection = tableView.numberOfRows(inSection: currentSection)
                if rowCountInSection > 0 {
                    let indexPath = IndexPath(row: 0, section: currentSection)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
            if isTouchingIndexView {
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
            }
        }
    }
    
    
    func onActionWithScroll() {
        if isTouchingIndexView {
            // 当滑动tableView视图时，另一手指滑动索引视图，让tableView滑动失效
            tableView.panGestureRecognizer.isEnabled = false
            tableView.panGestureRecognizer.isEnabled = true
            return // 当滑动索引视图时，tableView滚动不能影响索引位置
        }else {
            self.configCurrentSection()
        }
    }
    
    
    
    
    
    
    // MARK: ----------------- Display -----------------
    
    ///default指示器的贝塞尔曲线
    func getIndicatorPath(radius: CGFloat) -> UIBezierPath {
        let radius_4_pi = sin(CGFloat.pi / 4.0) * radius
        let margin = radius_4_pi * 2 - radius
        
        let startPoint = CGPoint(x: margin + radius + radius_4_pi, y: radius - radius_4_pi)
        let trianglePoint = CGPoint(x: 4 * radius_4_pi, y: radius)
        let centerPoint = CGPoint(x: margin + radius, y: radius)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: startPoint)
        bezierPath.addArc(withCenter: centerPoint, radius: radius, startAngle: -(CGFloat.pi/4), endAngle: CGFloat.pi/4, clockwise: false)
        bezierPath.addLine(to: trianglePoint)
        bezierPath.addLine(to: startPoint)
        bezierPath.close()
        return bezierPath
    }
    
    func createSearchLayer(indexItem: IndexItem) -> CAShapeLayer {
        let radius = indexItem.height / 4
        let margin = indexItem.height / 4
        let start = radius * 2.5 + margin
        let end = radius + sin(CGFloat.pi/4) * radius + margin
        let path = UIBezierPath()
        path.move(to: CGPoint(x: start, y: start))
        path.addLine(to: CGPoint(x: end, y: end))
        path.addArc(withCenter: CGPoint(x: radius + margin, y: radius + margin), radius: radius, startAngle: CGFloat.pi/4, endAngle: 2*CGFloat.pi + CGFloat.pi/4, clockwise: true)
        path.close()
        
        let layer = CAShapeLayer()
        layer.fillColor = indexItem.bgColor.cgColor
        layer.strokeColor = indexItem.textColor.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.lineWidth = indexItem.height / 12
        layer.path = path.cgPath
        return layer
    }
    
    ///创建一个指示器
    func getIndicatorView(indicator: Indicator) -> UILabel {
        let label = UILabel()
        label.layer.backgroundColor = indicator.bgColor.cgColor
        label.textColor = indicator.textColor
        label.font = indicator.textFont
        label.textAlignment = .center
        label.isHidden = true
        
        switch indicator.style {
        case .defualt:
            let radius = indicator.height / 2.0
            let radius_4pi = sin(CGFloat.pi/4.0) * radius
            label.bounds = CGRect(x: 0, y: 0, width: 4 * radius_4pi, height: 2 * radius)
            
            let maskLayer = CAShapeLayer()
            let bezierPath = getIndicatorPath(radius: indicator.height / 2.0)
            maskLayer.path = bezierPath.cgPath
            label.layer.mask = maskLayer
            
        case .toast:
            label.bounds = CGRect(x: 0, y: 0, width: indicator.height, height: indicator.height)
            label.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
            label.layer.cornerRadius = indicator.cornerRadius
        }
        return label
    }
    
    
    
    
    func showIndicator(animated: Bool) {
        if currentSection >= subTextLayers.count { return }
        if currentSection < 0 {
            if currentSection == kSearchSection {
                hideIndicator(animated: animated)
            }
            return
        }
        
        guard let indicatorConfig = config.indicator, let indicatorView = self.indicator else { return }
        let textLayer = subTextLayers[currentSection]
        switch indicatorConfig.style {
        case .defualt:
            let x = bounds.size.width - indicatorView.bounds.size.width / 2 - indicatorConfig.rightMargin
            indicatorView.center = CGPoint(x: x, y: textLayer.position.y)
        case .toast:
            indicatorView.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        }
        
        indicatorView.text = textLayer.string as? String
       
        indicatorView.isHidden = false
        if animated {
            indicatorView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                indicatorView.alpha = 1
            }
        }else {
            indicatorView.alpha = 1
        }
    }
    
    func hideIndicator(animated: Bool) {
        guard let indicatorView = indicator, !indicatorView.isHidden else { return }
        indicatorView.alpha = 1
        if animated {
            UIView.animate(withDuration: 0.25) {
                indicatorView.alpha = 0
            } completion: { (isFinished) in
                indicatorView.alpha = 1
                indicatorView.isHidden = true
            }
        }else {
            indicatorView.isHidden = true
        }
    }
    
    
    func refreshTextLayer(isSelected: Bool) {
        if currentSection < 0 || currentSection >= subTextLayers.count { return }
        let indexItem = config.indexItem
        
        let textLayer = subTextLayers[currentSection]
        let backgroundColor: UIColor
        let textColor: UIColor
        let font: UIFont
        if isSelected {
            backgroundColor = indexItem.selectedBgColor
            textColor = indexItem.selectedTextColor
            font = indexItem.selectedTextFont ?? indexItem.textFont
        }else {
            backgroundColor = indexItem.bgColor
            textColor = indexItem.textColor
            font = indexItem.textFont
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.backgroundColor = backgroundColor.cgColor
        textLayer.foregroundColor = textColor.cgColor
        textLayer.itemFont = font
        CATransaction.commit()
    }
    
    
    // MARK: ----------------- UITouch and UIEvent -----------------
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 当滑动索引视图时，防止其他手指去触发事件
        if isTouchingIndexView { return true }
        
        guard let firstLayer = searchLayer ?? subTextLayers.first else { return false }
        guard let lastLayer = subTextLayers.last ?? searchLayer else { return false }
        
        let space = config.indexItem.rightMargin * 2
        if point.x > bounds.size.width - space - config.indexItem.height
            && point.x <= bounds.size.width
            && point.y > firstLayer.frame.minY - space
            && point.y < lastLayer.frame.maxY + space {
            return true
        }
        return false
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isTouchingIndexView = true
        let location = touch.location(in: self)
        let currentPosition = getPositionOfTextLayerInY(y: location.y, margin: kIndexViewMargin, spacing: kIndexViewSpace)
        if currentPosition < 0 || currentPosition >= indexs.count{
            return true
        }
        
        let deta = searchLayer == nil ? 0 : 1
        let currentSection = currentPosition - deta
        self.currentSection = currentSection
        
        showIndicator(animated: true)
        onActionWithDidSelect()
        delegate?.sectionIndexView(self, didSelectSectionAt: self.currentSection)
        
        return true
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isTouchingIndexView = true
        let location = touch.location(in: self)
        var currentPosition = getPositionOfTextLayerInY(y: location.y, margin: kIndexViewMargin, spacing: kIndexViewSpace)
        
        if currentSection < 0 {
            currentSection = 0
        }else if currentPosition >= indexs.count {
            currentPosition = indexs.count - 1
        }
        
        let deta = searchLayer == nil ? 0 : 1
        let currentSection = currentPosition - deta
        if currentSection == self.currentSection { return true }
        
        self.currentSection = currentSection
        showIndicator(animated: false)
        onActionWithDidSelect()
        
        delegate?.sectionIndexView(self, didSelectSectionAt: self.currentSection)
        
        return true
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isTouchingIndexView = false
        let oldCurrentPosition = self.currentSection
        refreshCurrentSection()
        if oldCurrentPosition != self.currentSection {
            showIndicator(animated: false)
        }
        hideIndicator(animated: true)
    }
    
    
    override func cancelTracking(with event: UIEvent?) {
        isTouchingIndexView = false
        let oldCurrentPosition = self.currentSection
        refreshCurrentSection()
        if oldCurrentPosition != self.currentSection {
            showIndicator(animated: false)
        }
        hideIndicator(animated: true)
    }
    
    
    
    
}



extension SectionIndexView {
    
    var kIndexViewSpace: CGFloat {
        let s = config.indexItem.height + config.indexItem.spacing
        return s
    }
    
    var kIndexViewMargin: CGFloat {
        let m = (bounds.size.height - kIndexViewSpace * CGFloat(indexs.count)) / 2.0
        return m
    }
    
    var kIndexViewInsetTop: CGFloat {
        let t = translucentForTableViewInNavigationBar ? UIApplication.shared.statusBarFrame.size.height + 44 : 0
        return t
    }
    
}
