//
//  CodeScanningViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/16.
//

import UIKit

class CodeScanningViewController: UIViewController {
    
    var scanner: QRCodeScanner!
    
    //扫描结果回调
    var scanSuccessed: ((_ results: [String]?) -> Void)?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        createQRCodeScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let naviBar = navigationController?.navigationBar
        naviBar?.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        naviBar?.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let naviBar = navigationController?.navigationBar
        naviBar?.setBackgroundImage(nil, for: UIBarMetrics.default)
        naviBar?.shadowImage = nil
    }
    
    //MARK: ----------------- UI -----------------
    
    private func setUI() {
        self.title = "QRCode Scanner"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        btn.setImage(UIImage(named: "icon_back_white"), for: .normal)
        btn.addTarget(self, action: #selector(closeClicked(_:)), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItems = [backItem]
        
        let btn2 = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        btn2.setTitle("闪光灯", for: .normal)
        btn2.addTarget(self, action: #selector(flashClicked(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: btn2)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func closeClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func flashClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isOpen = sender.isSelected
        scanner.openTorch(isOpen)
    }
    
    //MARK: ----------------- 扫描器 -----------------
    ///创建扫描器
    private func createQRCodeScanner() {
        let w = kScreenW*(3/4)
        let scanRect = CGRect(x: (kScreenW - w)/2.0, y: (kScreenH - w)/2.0, width: w, height: w)
        scanner = QRCodeScanner(previewRect: view.bounds, scanRect: scanRect)
        scanner.completed = {[weak self] results in
            self?.scanSuccessed?(results)
            self?.showResultAlert(results: results)
        }
        self.view.addSubview(scanner.preview)
    }
    
    
    
    //MARK: ----------------- Other -----------------
    
    private func showResultAlert(results: [String]?) {
        guard let results = results else { return }
        let alert = UIAlertController(title: "二维码扫描结果", message: results.joined(separator: ","), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            //继续扫描
            self?.scanner.startScanning()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}
