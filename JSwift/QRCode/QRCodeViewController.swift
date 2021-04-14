//
//  QRCodeViewController.swift
//  JSwift
//
//  Created by jps on 2021/4/2.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    //生成二维码
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generationBtn: UIButton!
    @IBOutlet weak var resultImageView: UIImageView!
    //识别图片中的二维码结果
    @IBOutlet weak var imageResultLabel: UILabel!
    //扫描二维码
    @IBOutlet weak var scanResultLabel: UILabel!
    
    let generator = QRCodeGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        generator.brightnessUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        generator.brightnessRecover()
    }
    
    
    
    //点击生成二维码
    @IBAction func generationClicked(_ sender: Any) {
        guard let str = textField.text, !str.isEmpty else { return }
        
        //let image = generator.generateCode(inputStr: str, logo: UIImage(named: "Pikachu"))
        let image = generator.generateGradientCode(str: str)
        resultImageView.image = image
    }
    
    //识别图片中的二维码 (从相册选择)
    @IBAction func recognitionFromPhotoLib(_ sender: Any) {
        showImagePicker(isCamera: false)
        /*
        guard let image = resultImageView.image else { return }
        let feature = QRCodeUtil.extractQRCodeInfo(image: image)?.first
        imageResultLabel.text = "识别结果: \(feature?.messageString ?? "nil")"
        */
    }
    
    
    @IBAction func recognitionFromCamera(_ sender: Any) {
        //showImagePicker(isCamera: true)
        
        generator.saveQRCodeImageToAlbum(screenView: self.view)
    }
    
    
    //扫描二维码
    @IBAction func recognitionByScan(_ sender: Any) {
        let qrScanVC = QRCodeScanViewController()
        self.navigationController?.pushViewController(qrScanVC, animated: true)
        qrScanVC.completed = {[weak self] results in
            //是链接，跳转网页
            //普通文字，就展示出来
            print("扫描成功回调: \(results ?? [])")
            self?.scanResultLabel.text = "扫描结果: \(results ?? [])"
        }
    }
    
}



extension QRCodeViewController {
    func showImagePicker(isCamera: Bool) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = isCamera ? .camera : .photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
}
extension QRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取选择的原图
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let results = QRCodeRecognizer.recognitionQRCode(image: image)
        imageResultLabel.text = "识别结果: \(results ?? [])"
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
}
