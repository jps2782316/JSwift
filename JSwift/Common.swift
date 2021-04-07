//
//  Common.swift
//  JSwift
//
//  Created by jps on 2021/4/7.
//

import Foundation
import UIKit

var keyWindow: UIWindow? {
    let keyWindows = UIApplication.shared.windows.filter({ $0.isKeyWindow })
    return keyWindows.first
}


///屏幕宽度
let kScreenW = UIScreen.main.bounds.size.width
///屏幕高度
let kScreenH = UIScreen.main.bounds.size.height



///顶部安全区高度
var kTopSafeHeigh: CGFloat {
    //iOS 11之前没有安全区，状态栏高度固定20个点
    var top: CGFloat = 20
    if #available(iOS 11.0, *) {
        top = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        //top = UIView.appearance().safeAreaInsets.top 取到的为0
    }
    return top
}

///底部安全区高度
var kBottomSafeHeight: CGFloat {
    //iOS 11之前(即iPhoneX之前)没有安全区，底部为0
    var bottom: CGFloat = 0
    if #available(iOS 11.0, *) {
        bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return bottom
}

//状态栏高度 (不要写成常量，6splus启动时获取到的为0)
var kStatusBarHeight: CGFloat {
    var height: CGFloat
    if #available(iOS 13.0, *) {
        height = UIView.appearance().window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else {
         height = UIApplication.shared.statusBarFrame.height
    }
    return height
}
