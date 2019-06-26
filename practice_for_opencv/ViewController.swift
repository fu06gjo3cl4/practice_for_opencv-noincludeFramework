//
//  ViewController.swift
//  practice_for_opencv
//
//  Created by 黃麒安 on 2019/6/24.
//  Copyright © 2019 黃麒安. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session = AVCaptureSession()
    var previewImage = UIImage()
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLiveVideo()
//        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.setPreviewImage), userInfo: nil, repeats: true)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLiveVideo() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        session.startRunning()
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
//        connection.videoOrientation = AVCaptureVideoOrientation.portrait;
//        updatePreviewImage(sampleBuffer:sampleBuffer)
        
    }
    func updatePreviewImage(sampleBuffer: CMSampleBuffer){
        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        previewImage = self.convertCIImageToUIImage(cmage: ciimage)
    }
    func convertCIImageToUIImage(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.right)
        return image
    }
    
    @objc func setPreviewImage(){
//        let image = ImageConverter.getBinaryImage(previewImage)
//        imageView.image = image
    }
}




