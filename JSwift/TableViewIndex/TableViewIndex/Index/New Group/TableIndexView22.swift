//
//  TableViewIndex22.swift
//  JSwift
//
//  Created by jps on 2021/4/20.
//

import UIKit




extension TableViewIndex22 {
    
    ///每个item的高度:  item的height + 两个item之间的间距
    var kIndexViewSpace: CGFloat {
        let s = config.indexItem.height + config.indexItem.spacing
        return s
    }
    
    ///第一个layer布局的y值
    var kIndexViewMargin: CGFloat {
        let m = (bounds.size.height - kIndexViewSpace * CGFloat(indexs.count)) / 2.0
        return m
    }
    
    var kIndexViewInsetTop: CGFloat {
        let t = isTranslucentNavi ? UIApplication.shared.statusBarFrame.size.height + 44 : 0
        return t
    }
    
    var kInvalidSection: Int {
        return Int.max
    }
    var kSearchSection: Int {
        return -1
    }
    
    // 根据section值获取TextLayer的中心点y值
    func getTextLayerCenterY(index: CGFloat, firstItemY: CGFloat, perItemH: CGFloat) -> CGFloat {
        return firstItemY + (index + 1.0 / 2) * perItemH
    }
    
    // 根据触摸的y值，计算出点击的是第几个索引
    func getPositionOfTextLayerInY(y: CGFloat, firstItemY: CGFloat, perItemH: CGFloat) -> Int {
        /*
         思考: 这里为什么要减去1/2。(其实可以减去1)
         答案: 减去1/2是为了省去下面的取整判断。因为如果position<=0.5(其实是<=1)，没有悬念的就应该是选中第0个，
         减去1/2就为负数，直接返回第0个就行了，没必要再去向上取整，然后再去比较centerY和点击的位置，去决定到底要选中第0个还是第1个。
         */
        let position = (y - firstItemY) / perItemH - 1 / 2
        if position <= 0 { return 0 }
        
        let bigger = ceil(position) //向上取整
        let smaller = bigger - 1
        let biggerCenterY = getTextLayerCenterY(index: bigger, firstItemY: firstItemY, perItemH: perItemH)
        let smallerCenterY = getTextLayerCenterY(index: smaller, firstItemY: firstItemY, perItemH: perItemH)
        /*
        比如计算出来的position是0.6，这时因该选中第0个。
         向上取整之后bigger为1，smaller为0。sumCenterY = biggerCenterY + smallerCenterY，2*y。
         2*y == sumCenterY, 说明点击的位置刚好在smaller的最大y处。应该选中smaller。
         2*y < sumCenterY, 说明点击的位置还在smaller的frame内，应该选中smaller。
         2*y > sumCenterY, 说明点击的位置已大于smaller的frame，应该选中bigger。
         */
        let final = (biggerCenterY + smallerCenterY > 2 * y) ? smaller : bigger
        return Int(final)
    }
    
}


class TableViewIndex22: UIControl {
    
    //weak var delegate: SectionIndexViewDelegate?
    
    // 索引视图数据源
    var indexs: [String] = [] {
        didSet {
            setupItemLayers()
            updateIndexItemSelectedState()
        }
    }
    // 当前索引位置
    var currentSection: Int = Int.max {
        willSet { refreshTextLayer(isSelected: false) }
        didSet {
            refreshTextLayer(isSelected: true)
        }
    }
    
    /*
     导航是否半透明:
     如果你的tableview的contentOffset受导航栏影响，传true。不受影响，则传false。(具体收不收影响，取决于你的导航栏的isTranslucent属性和tableView的具体布局方式)
     导航栏的isTranslucent为true时，tableView.contentOffset.y为-91 (状态栏高度47+导航栏高度44)
     导航栏的isTranslucent为false时，tableView.contentOffset.y为0
     */
    var isTranslucentNavi: Bool = false
    
    ///tableView从第几个section开始使用索引 Default = 0
    var startSection: Int = 0 {
        didSet { updateIndexItemSelectedState() }
    }
    ///索引配置
    private var config: IndexConfig
    
    
    private(set) var itemLayers: [TextItemLayer] = []
    
    // 是否正在点击/滑动索引视图
    private var isTouching: Bool = false
    
    
    
    private var searchLayer: CAShapeLayer!
   
    private var indicatorView: UILabel?
    
    weak var tableView: UITableView!
    
    
    ///索引内容视图
    var indexView: IndexView!
    ///索引背景
    var backgroundView: UIView!
    
    
    
    // 触感反馈
    private lazy var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    
    init(config: IndexConfig, tableView: UITableView) {
        self.config = config
        self.tableView = tableView
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUI() {
        indexView = IndexView(frame: .zero)
        self.addSubview(indexView)
        backgroundView = IndexBackgroudView()
        self.insertSubview(backgroundView, at: 0)
        
        if let indicatorConfig = config.indicator {
            indicatorView = createIndicatorView(indicator: indicatorConfig)
            self.addSubview(indicatorView!)
        }
    }
    
    
    func update(config: IndexConfig) {
        self.config = config
        if let indicator = config.indicator, indicatorView == nil {
            indicatorView = createIndicatorView(indicator: indicator)
            self.addSubview(indicatorView!)
        }else {
            indicatorView?.removeFromSuperview()
            indicatorView = nil
        }
    }
    
    //MARK: --------------------- 创建子控件 ---------------------
    
    ///根据数据源，创建itemLayers
    private func setupItemLayers() {
        //1. 是否有搜索
        let hasSearch = indexs.first == UITableView.indexSearch
        var deta = 0
        if hasSearch {
            if (searchLayer == nil) {
                searchLayer = createSearchLayer(indexItem: config.indexItem)
                self.layer.addSublayer(searchLayer!)
            }
            searchLayer?.isHidden = false
            deta = 1
        }else  {
            searchLayer?.removeFromSuperlayer()
            searchLayer = nil
        }
        
        //2. 保持数据源和layer数一致
        let countDifference = indexs.count - deta - itemLayers.count
        if countDifference > 0 { //layer少了，创建layer
            for _ in 0..<countDifference {
                let textLayer = TextItemLayer()
                //self.layer.addSublayer(textLayer)
                itemLayers.append(textLayer)
            }
        }else {
            for _ in 0..<(-countDifference) { // layer多了，移除掉多余的layer
                let textLayer = itemLayers.last
                textLayer?.removeFromSuperlayer()
                itemLayers.removeLast()
            }
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let indexItem = config.indexItem
        
        //3. 设置layer的frame和其他属性
        if hasSearch {
            let x = bounds.size.width - indexItem.rightMargin - indexItem.height
            let y = getTextLayerCenterY(index: 0, firstItemY: kIndexViewMargin, perItemH: kIndexViewSpace) - indexItem.height / 2
            searchLayer.frame = CGRect(x: x, y: y, width: indexItem.height, height: indexItem.height)
            searchLayer.cornerRadius = indexItem.height / 2
            searchLayer.contentsScale = UIScreen.main.scale
            searchLayer.backgroundColor = indexItem.bgColor.cgColor
        }
        
        for (i, textLayer) in itemLayers.enumerated() {
            let section = i + deta
            textLayer.string = indexs[section]
            textLayer.itemFont = indexItem.textFont
            textLayer.cornerRadius = indexItem.height / 2.0
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.backgroundColor = indexItem.bgColor.cgColor
            textLayer.foregroundColor = indexItem.textColor.cgColor
        }
        
        let layout = Layout(items: itemLayers, config: config, bounds: self.bounds)
        indexView.frame = layout.contentFrame
        backgroundView.frame = layout.backgroundFrame
        indexView.addItmes(itemLayers)
        
        
        CATransaction.commit()
    }
    
    
    private func updateIndexItemSelectedState() {
        let currentIndex = caculateIndexWithFirstVisibleSection()
        self.currentSection = currentIndex ?? 0
    }
    
    ///根据当前屏幕所显示的内容，计算出对应的索引值
    private func caculateIndexWithFirstVisibleSection() -> Int? {
        var currentSection = kInvalidSection
        
        //1. 找出tableView显示的是第几个section
        guard let firstVisibleSection = tableView.indexPathsForVisibleRows?.first?.section else { return nil }
        let insetTop = kIndexViewInsetTop
        
        currentSection = firstVisibleSection
        
        //2. 偏移量 < 第0个section的y时，索引记为选中search
        var isSelectSearchLayer = false
        if currentSection == 0 && (searchLayer != nil) && currentSection < tableView.numberOfSections {
            /*
             有高度为60的headerView时，滑动最顶上，
             sectionFrame.origin.y为60,
             导航栏的isTranslucent为true时，tableView.contentOffset.y为-91 (状态栏高度47+导航栏高度44)
             导航栏的isTranslucent为false时，tableView.contentOffset.y为0
             
             以isTranslucent为false理解，比较清晰
             向上滑动tableView时contentOffset.y是不断变大的，直到变为>60时，这时就说明第一个section已经在最顶部了，所以isSelectSearchLayer就为false了。
             */
            let sectionFrame = tableView.rect(forSection: currentSection)
            isSelectSearchLayer = (sectionFrame.origin.y - tableView.contentOffset.y - insetTop) > 0
            print("contentOffset: \(tableView.contentOffset.y), isSearch: \(isSelectSearchLayer)")
        }
        
        if isSelectSearchLayer {
            //设置currentSection为-1，设置layer选中时，是过滤掉负数的，所以就不会选中search
            currentSection = kSearchSection
        }else {
            //一开始选中的currentSection是0，如果忽略3个组，这时候就变成当前选中-3，而设置索引的选中时，是过滤掉负数的，所以索引看起来就没变化。也就是说不需要索引定位的组，是不在layerItems里的。而currentSection默认值为max，超出itemLayers.count,也是被过滤掉的。
            currentSection = currentSection - startSection
        }
        
        return currentSection
    }
    
    
    
    //MARK: --------------------- Event Handle ---------------------
    
    /*
     滑动tableView，在scrollViewDidScroll中会调用此方法更新索引
     滑动索引列表，结束或取消时，会调用此方法更新索引
     两个同时滑动时，会打断tableview的滑动，只响应索引的滑动
     */
    func refreshCurrentSection() {
        if isTouching {
            // 当滑动tableView视图时，另一手指滑动索引视图，让tableView滑动失效
            tableView.panGestureRecognizer.isEnabled = false
            tableView.panGestureRecognizer.isEnabled = true
            return // 当滑动索引视图时，tableView滚动不能影响索引位置
        }else {
            self.updateIndexItemSelectedState()
        }
    }
    
    
    ///选中索引。滚动到当前section的地一行，或滚动到表的最顶端(显示出搜索来)
    private func select(section: Int) {
        if (currentSection < 0 && currentSection != kSearchSection) || currentSection >= itemLayers.count {
            return
        }
        
        if currentSection == kSearchSection {
            let insetTop = kIndexViewInsetTop
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
            if isTouching {
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: ----------------- Index Indicator -----------------
    
    ///指示器的贝塞尔曲线
    private func createIndicatorPath(radius: CGFloat) -> UIBezierPath {
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
    
    ///创建一个指示器
    private func createIndicatorView(indicator: Indicator) -> UILabel {
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
            let bezierPath = createIndicatorPath(radius: indicator.height / 2.0)
            maskLayer.path = bezierPath.cgPath
            label.layer.mask = maskLayer
            
        case .toast:
            label.bounds = CGRect(x: 0, y: 0, width: indicator.height, height: indicator.height)
            label.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
            label.layer.cornerRadius = indicator.cornerRadius
        }
        return label
    }
    
    ///显示索引指示器
    private func showIndicator(animated: Bool) {
        if currentSection >= itemLayers.count { return }
        if currentSection < 0 {
            if currentSection == kSearchSection {
                hideIndicator(animated: animated)
            }
            return
        }
        
        guard let indicatorConfig = config.indicator, let indicatorView = self.indicatorView else { return }
        let textLayer = itemLayers[currentSection]
        switch indicatorConfig.style {
        case .defualt:
            let x = bounds.size.width - indicatorView.bounds.size.width / 2 - indicatorConfig.rightMargin
            let position = indexView.convert(textLayer.position, to: self)
            indicatorView.center = CGPoint(x: x, y: position.y)
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
    
    ///隐藏索引指示器
    private func hideIndicator(animated: Bool) {
        guard let indicatorView = indicatorView, !indicatorView.isHidden else { return }
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
    
    
    // MARK: ----------------- Index Item -----------------
    
    private func createSearchLayer(indexItem: IndexItem) -> CAShapeLayer {
        let radius = indexItem.height / 4
        let margin = indexItem.height / 4
        let start = radius * 2.5 + margin
        let end = radius + sin(CGFloat.pi/4) * radius + margin
        //放大镜贝塞尔曲线
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
    
    private func refreshTextLayer(isSelected: Bool) {
        if currentSection < 0 || currentSection >= itemLayers.count { return }
        let indexItem = config.indexItem
        
        let textLayer = itemLayers[currentSection]
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
        if isTouching { return true }
        
        guard let firstLayer = searchLayer ?? itemLayers.first else { return false }
        guard let lastLayer = itemLayers.last ?? searchLayer else { return false }
        
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
        isTouching = true
        let location = touch.location(in: self)
        //当前选中的是第几个索引
        let currentIndex = getPositionOfTextLayerInY(y: location.y, firstItemY: kIndexViewMargin, perItemH: kIndexViewSpace)
        
        if currentIndex >= 0 && currentIndex < indexs.count {
            let deta = searchLayer == nil ? 0 : 1
            self.currentSection = currentIndex - deta
            
            showIndicator(animated: true)
            select(section: currentSection)
            
            //delegate?.sectionIndexView(self, didSelectSectionAt: self.currentSection)
        }
        
        return true
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isTouching = true
        let location = touch.location(in: self)
        //当前选中的是第几个索引
        var currentIndex = getPositionOfTextLayerInY(y: location.y, firstItemY: kIndexViewMargin, perItemH: kIndexViewSpace)
        if currentIndex >= indexs.count {
            currentIndex = indexs.count - 1
        }
        
        let deta = searchLayer == nil ? 0 : 1
        let currentSection = currentIndex - deta
        if currentSection != self.currentSection {
            self.currentSection = currentSection
            
            showIndicator(animated: false)
            select(section: currentSection)
            
            //delegate?.sectionIndexView(self, didSelectSectionAt: self.currentSection)
        }
        
        
        return true
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isTouching = false
        let oldCurrentPosition = self.currentSection
        refreshCurrentSection()
        if oldCurrentPosition != self.currentSection {
            showIndicator(animated: false)
        }
        hideIndicator(animated: true)
    }
    
    
    override func cancelTracking(with event: UIEvent?) {
        isTouching = false
        let oldCurrentPosition = self.currentSection
        refreshCurrentSection()
        if oldCurrentPosition != self.currentSection {
            showIndicator(animated: false)
        }
        hideIndicator(animated: true)
    }
    
    
    
    
}




