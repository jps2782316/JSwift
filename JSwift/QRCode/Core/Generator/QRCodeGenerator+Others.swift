//
//  QRCodeGenerator+Others.swift
//  JSwift
//
//  Created by jps on 2021/4/7.
//

import Foundation
import UIKit

extension QRCodeGenerator {
    /*
     iOS截屏并修改截图然后分享的功能实现
     https://blog.csdn.net/weixin_30326745/article/details/96877506?utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control
     */
    
    //MARK: ----------------- 保存二维码到相册 -----------------
    
    //iOS下将照片保存到相册的三种方法 https://www.jianshu.com/p/bf20733ba19b
    
    
    /// 截取二维码，并保存到相册
    /// - Parameter screenView: 需要截取的视图
    func saveQRCodeImageToAlbum(screenView: UIView) {
        /*
         注意⚠️: 开启上下文时，
         UIGraphicsBeginImageContext: 截取的图片很模糊
         UIGraphicsBeginImageContextWithOptions: 截取的图片很清晰，跟真实界面一样清晰
         */
        //设置截取大小
        UIGraphicsBeginImageContextWithOptions(screenView.bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        screenView.layer.render(in: context)
        //获得截取到的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //保存到相册
        if let image = image {
            writeToPhotoAlbum(image: image)
        }
        
    }
    
    //保存图片到相册
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageToPhotoAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func saveImageToPhotoAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("保存图片到相册错误: \(error)")
        }else {
            print("保存图片成功")
        }
    }
    
    
}
