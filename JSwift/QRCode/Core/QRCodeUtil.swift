//
//  QRCode.swift
//  JSwift
//
//  Created by jps on 2021/4/2.
//

import Foundation
import UIKit


class QRCodeUtil {
    
    /*
     Swift之二维码的生成、识别和扫描
     https://juejin.cn/post/6844903576817369096
     
     //https://www.hangge.com/blog/cache/detail_909.html
     
     //iOS--各种样式的二维码生成
     https://www.jianshu.com/p/52abb62d0d39
     
     //iOS 原生库(CoreImage)实现生成二维码,封装的工具类,不依赖第三方库,可自定义背景颜色,添加logo(Swift 4.0)
     https://www.yaozuopan.top/index.php/archives/61/
     
     iOS最全的二维码篇
     https://ctolib.com/topics-84090.html
     
     iOS开发-定制多样式二维码
     https://my.oschina.net/u/2473136/blog/524847
     
     二维码扫码优化技术方案
     https://juejin.cn/post/6875192005036048392
     
     iOS 扫描二维码/条形码
     https://juejin.cn/post/6844903734263152648
     
     [iOS]艺术二维码之路。 (比较有用)
     https://juejin.cn/post/6844903525143543822
     
     //第三方库 (比较有用)
     https://github.com/EFPrefix/EFQRCode //swift
     https://github.com/sylnsfar/qrcode //python
     */
    
    
    
    
    
    /*
     注意⚠️:
     size设置的越小，识别率越低
     同样的size，内容越长，生成的团越密集，识别度就越高
     */
    
    /*
     了解二维码生成原理，找出为啥识别困难。
     二维码角上的框框，不论图案有多复杂或多简单，为啥总是7个点
     
     
     注意:
     当shapeStyle为
     .square时，就算只放大10倍，只生成一个字母"a"的二维码，也很容易识别
     .circle时，放大10倍基本无法识别，在放大十倍的情况下，要谁让很复杂的内容，生成比较复杂的二维码图案，才容易识别
     */
    
    
    /*
     绘制原理:
     每一个点都是一个贝塞尔曲线，直接绘制贝塞尔曲线就行了。
     */
    
    
    /*
     高级:
     识别到多张二维码时，在图片中标出来，用户选哪张，就处理哪张
     艺术二维码
     
     //基础功能:
     二维码界面自动调高亮度、闪光灯、扫描动画
     二维码保存到相册(支持截屏保存、单独保存二维码)
     二维码中间添加logo(logo描边)
     */

    
}




