//
//  QRCodeScanViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/2.
//

import UIKit
import AVFoundation

/*
 优化: 识别到多张二维码时，在图片中标出来，用户选哪张，就处理哪张
 扫描动画
 */


///二维码扫描视图
class QRCodeScanViewController: UIViewController {
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    
    
    ///输入输出中间桥梁(会话)
    var session: AVCaptureSession!
    
    //扫描结果回调
    var completed: ((_ results: [String]?) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScanningVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func addScanningVideo() {
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
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //添加中间的探测区域绿框
        let scanSize = CGSize(width: screenW*(3/4), height: screenW*(3/4))
        let scanRectView = UIView()
        self.view.addSubview(scanRectView)
        scanRectView.bounds = CGRect(x: 0, y: 0, width: scanSize.width, height: scanSize.height)
        scanRectView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        scanRectView.layer.borderColor = UIColor.green.cgColor
        scanRectView.layer.borderWidth = 1
        
        //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）。注意x,y交换位置
        let rect = CGRect(x: scanRectView.frame.minY / screenH, y: scanRectView.frame.minX / screenW, width: scanRectView.frame.height / screenH, height: scanRectView.frame.width / screenW)
        metadataOutput.rectOfInterest = rect
        
        //10. 开始扫描
        session.startRunning()
    }
    
}


extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //1. 取出扫描到的数据: metadataObjects
        //2. 以震动的形式告知用户扫描成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //3. 关闭session
        session.stopRunning()
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
        print("二维码扫描内容为: \(resultArr)")
        showResultAlert(results: resultArr)
    }
    
    
    private func showResultAlert(results: [String]) {
        let alert = UIAlertController(title: "二维码扫描结果", message: results.joined(separator: ","), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            //继续扫描
            self?.session.startRunning()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
