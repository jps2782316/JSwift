//
//  QRCodeScanViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/2.
//

import UIKit
import AVFoundation



///二维码扫描视图
class QRCodeScanViewController: UIViewController {
    
    
    
    ///输入输出中间桥梁(会话)
    var session: AVCaptureSession!
    //扫描结果回调
    var completed: ((_ results: [String]?) -> Void)?
    
    
//    var lineLayer: CAShapeLayer!
//    var animation: CABasicAnimation!
    
    var preview: QRCodeScanningPreview!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScanningVideo()
        setUI()
        
        preview = QRCodeScanningPreview(frame: view.frame)
        preview.autoresizingMask = .flexibleHeight
        view.addSubview(preview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    
    private func setUI() {
        let y = kTopSafeHeigh
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 20, y: y, width: 50, height: 50)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        let flashBtn = UIButton()
        flashBtn.frame = CGRect(x: kScreenW-100, y: y, width: 100, height: 50)
        flashBtn.setTitle("闪光灯", for: .normal)
        flashBtn.setImage(nil, for: .normal)
        flashBtn.setImage(nil, for: .selected)
        flashBtn.addTarget(self, action: #selector(flashClicked(_:)), for: .touchUpInside)
        self.view.addSubview(flashBtn)
    }
    
    @objc func closeClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func flashClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isOpen = sender.isSelected
        openTorch(isOpen)
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
        preview.layer.insertSublayer(previewLayer, at: 0)
        
        //添加中间的探测区域绿框
        let w = kScreenW*(3/4)
        let h = kScreenW*(3/4)
        let scanRect = CGRect(x: (kScreenW - w)/2.0, y: (kScreenH - h)/2.0, width: w, height: h)
        
//        let scanRectView = UIView(frame: scanRect)
//        self.view.addSubview(scanRectView)
//        scanRectView.layer.borderColor = UIColor.green.cgColor
//        scanRectView.layer.borderWidth = 1
        
//        //遮罩
//        self.view.layer.backgroundColor = UIColor.black.cgColor
//        let maskPath = UIBezierPath(rect: self.view.bounds)
//        let subPath = UIBezierPath(rect: scanRect).reversing()
//        maskPath.append(subPath)
//        let maskLayer = CAShapeLayer()
//        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        maskLayer.path = maskPath.cgPath
//        self.view.layer.addSublayer(maskLayer)
//        
//        //扫描线
//        let lineFrame = CGRect(x: scanRect.origin.x, y: scanRect.origin.y, width: scanRect.width, height: 1.5)
//        let linePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: lineFrame.size))
//        lineLayer = CAShapeLayer()
//        lineLayer.frame = lineFrame
//        lineLayer.path = linePath.cgPath
//        lineLayer.fillColor = UIColor.blue.cgColor
//        lineLayer.shadowColor = UIColor.blue.cgColor
//        lineLayer.shadowRadius = 5
//        lineLayer.shadowOffset = CGSize.zero
//        lineLayer.shadowOpacity = 1.0
//        lineLayer.isHidden = false
//        self.view.layer.addSublayer(lineLayer)
//        //扫描动画
//        animation = CABasicAnimation(keyPath: "position.y")
//        animation.fromValue = lineFrame.origin.y
//        animation.toValue = lineFrame.origin.y + scanRect.height
//        animation.repeatCount = 100
//        animation.autoreverses = true
//        animation.duration = 2.0
        
        //9.设置有效扫描区域(默认整个屏幕区域)（每个取值0~1, 以屏幕右上角为坐标原点）。注意x,y交换位置
        let rect = CGRect(x: scanRect.minY / kScreenH, y: scanRect.minX / kScreenW, width: scanRect.height / kScreenH, height: scanRect.width / kScreenW)
        metadataOutput.rectOfInterest = rect
        
        //10. 开始扫描
        startScanning()
    }
    
    
    
    
}


extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
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


extension QRCodeScanViewController {
    
    ///打开/关闭闪光灯 / 手电筒
    private func openTorch(_ isOpen: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasFlash && device.hasTorch {
            do {
                try device.lockForConfiguration()
                //打开/关闭 闪光灯
                let isOn: AVCaptureDevice.TorchMode = isOpen ? .on : .off
                device.torchMode = isOn
                device.unlockForConfiguration()
            }catch {
                print("打开闪光灯错误: \(error)")
            }
        }
    }
    
}
