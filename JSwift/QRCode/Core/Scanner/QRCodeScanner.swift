//
//  QRCodeScanner.swift
//  JSwift
//
//  Created by jps on 2021/4/16.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeScanner: NSObject {
    
    //预览层
    var preview: QRCodeScanningPreview!
    
    ///输入输出中间桥梁(会话)
    var session: AVCaptureSession!
    //扫描结果回调
    var completed: ((_ results: [String]?) -> Void)?
    
    var scanRect: CGRect //扫描框的位置大小
    var previewRect: CGRect //整个预览层的位置大小
    
    
    init(previewRect: CGRect, scanRect: CGRect) {
        self.scanRect = scanRect
        self.previewRect = previewRect
        super.init()
        setPreviewUI()
        createScanningSession()
    }
    
    
    private func setPreviewUI() {
        preview = QRCodeScanningPreview(frame: previewRect, scanRect: scanRect)
        preview.maskColor = .clear
        preview.autoresizingMask = .flexibleHeight
    }
    
    //初始化扫描session
    private func createScanningSession() {
        //1.获取输入设备（摄像头）
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        //2.根据输入设备创建输入对象
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        //3.创建原数据的输出对象
        let metadataOutput = AVCaptureMetadataOutput()
        //4.设置代理监听输出对象输出的数据，在主线程中刷新
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //5.创建会话（桥梁）
        session = AVCaptureSession()
        //6.添加输入和输出到会话
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        if UIScreen.main.bounds.size.height < 500 {
            session.sessionPreset = .vga640x480
        }else {
            session.sessionPreset = .high
        }
        //7.告诉输出对象要输出什么样的数据(二维码还是条形码),要先创建会话才能设置
        metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
        //8.创建预览图层
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewRect
        preview.layer.insertSublayer(previewLayer, at: 0)
        
        //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）。注意x,y交换位置
        let rect = CGRect(x: scanRect.minY / previewRect.height, y: scanRect.minX / previewRect.width, width: scanRect.height / previewRect.height, height: scanRect.width / previewRect.width)
        metadataOutput.rectOfInterest = rect
        
        //10. 开始扫描
        startScanning()
    }
    
    
    
    ///开始扫描
    func startScanning() {
        session.startRunning()
        preview.startAnimation()
    }
    
    ///停止扫描
    func stopScanning() {
        session.stopRunning()
        preview.stopAnimation()
    }
    
    
    ///打开/关闭手电筒
    func openTorch(_ isOpen: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasFlash && device.hasTorch {
            do {
                try device.lockForConfiguration()
                let isOn: AVCaptureDevice.TorchMode = isOpen ? .on : .off
                device.torchMode = isOn
                device.unlockForConfiguration()
            }catch {
                print("打开闪光灯错误: \(error)")
            }
        }
    }
    
}



extension QRCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //1. 取出扫描到的数据: metadataObjects
        //2. 以震动的形式告知用户扫描成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //3. 关闭session
        stopScanning()
        //4. 遍历结果
        var resultArr = [String]()
        for result in metadataObjects {
            //转换成机器可读的编码数据
            if let code = result as? AVMetadataMachineReadableCodeObject {
                resultArr.append(code.stringValue ?? "")
            }else {
                resultArr.append(result.type.rawValue)
            }
        }
        completed?(resultArr)
    }
}
