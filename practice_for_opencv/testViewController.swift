//
//  testViewController.swift
//  practice_for_opencv
//
//  Created by 黃麒安 on 2019/6/25.
//  Copyright © 2019 黃麒安. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class testViewController: UIViewController {
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    
    @IBAction func btn_no_algorithm(_ sender: Any) {
        self.algorithmtype = 0
        setPreviewImage()
    }
    @IBAction func btn_algorithm1(_ sender: Any) {
        self.algorithmtype = 1
        setPreviewImage()
    }
    @IBAction func btn_algorithm2(_ sender: Any) {
        self.algorithmtype = 2
        setPreviewImage()
        
    }
    
    
    
    var videoURL: NSURL?
    var selectedImageFromPicker: UIImage?
    var thresholdtype: Int = 0
    var algorithmtype: Int = 0
    
    private var optionsTableView: UITableView? = nil
    var options: [Option] = [.THRESH_BINARY,.THRESH_BINARY_INV,.THRESH_TRUNC,.THRESH_TOZERO,.THRESH_TOZERO_INV,.THRESH_MASK]
    
    enum Option {
        case THRESH_BINARY
        case THRESH_BINARY_INV
        case THRESH_TRUNC
        case THRESH_TOZERO
        case THRESH_TOZERO_INV
        case THRESH_MASK
        
        var label: String {
            switch self {
            case .THRESH_BINARY: return "THRESH_BINARY"
            case .THRESH_BINARY_INV: return "THRESH_BINARY_INV"
            case .THRESH_TRUNC: return "THRESH_TRUNC"
            case .THRESH_TOZERO: return "THRESH_TOZERO"
            case .THRESH_TOZERO_INV: return "THRESH_TOZERO_INV"
            case .THRESH_MASK: return "THRESH_MASK"
            }
        }
    }
    
    @IBOutlet weak var imageview: UIImageView!{
        didSet{
            self.imageview.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var btn_upload: UIButton!
    var previewImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func optionsButtonTapped(_ sender: Any) {
        if let optionsTableView = self.optionsTableView {
            optionsTableView.removeFromSuperview()
            self.optionsTableView = nil
            return
        }
        
        let optionsTableView = UITableView()
        optionsTableView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.optionsTableView = optionsTableView
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self.view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 40))
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: sender as! UIView,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: optionsTableView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: sender,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 5))
        
        self.view.addSubview(optionsTableView)
        constraints.forEach { $0.isActive = true }
        
        let constraint = NSLayoutConstraint(item: optionsTableView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .height,
                                            multiplier: 1,
                                            constant: 220)
        constraint.isActive = true
    }
    
    @IBAction func value_change_by_slider1(_ sender: Any) {
        setPreviewImage()
    }
    
    @IBAction func value_change_by_slider2(_ sender: Any) {
        setPreviewImage()
    }

    @IBAction func Upload_Image(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        print(imagePickerController.mediaTypes)
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }
}
extension testViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    internal func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        //UIImagePickerController.InfoKey
        
        if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            let player = AVPlayer(url: videoURL as URL)

            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }

        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            imageview.image = pickedImage
            previewImage = pickedImage
            setPreviewImage()

        }
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @objc func setPreviewImage(){
//        let image = ImageConverter.getBinaryImage(previewImage)
        let image = ImageConverter.getBinaryImage(previewImage,thresh: slider1.value,maxval: slider2.value,thresholdtype: Int32(self.thresholdtype),algorithmtype: Int32(self.algorithmtype))
        imageview.image = image
    }
    
    
    
    
    
    
    
}

extension testViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if optionsTableView != nil {
            return 1
        }
        
        return 0
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionsTableView != nil {
            return options.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if optionsTableView != nil {
            return 40.0;
        }
        
        return 44.0;
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.backgroundView = nil
            cell?.backgroundColor = .clear
            cell?.textLabel?.textColor = .white
        }
        cell?.textLabel?.text = self.options[indexPath.row].label
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if optionsTableView != nil {
            tableView.deselectRow(at: indexPath, animated: true)
            
            optionsTableView?.removeFromSuperview()
            self.optionsTableView = nil
            
            self.optionTapped(self.options[indexPath.row])
        }
        
    }
    
    func optionTapped(_ option: Option) {
        switch option {
        case .THRESH_BINARY:
            self.thresholdtype = 0
            break
        case .THRESH_BINARY_INV:
            self.thresholdtype = 1
            break
        case .THRESH_TRUNC:
            self.thresholdtype = 2
            break
        case .THRESH_TOZERO:
            self.thresholdtype = 3
            break
        case .THRESH_TOZERO_INV:
            self.thresholdtype = 4
            break
        case .THRESH_MASK:
            self.thresholdtype = 7
            break
        default:
            self.thresholdtype = 0
            break
        }
        setPreviewImage()
    }
    
//    enum ThresholdTypes {
//        THRESH_BINARY     = 0, //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{maxval}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
//        THRESH_BINARY_INV = 1, //!< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{maxval}}{otherwise}\f]
//        THRESH_TRUNC      = 2, //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{threshold}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
//        THRESH_TOZERO     = 3, //!< \f[\texttt{dst} (x,y) =  \fork{\texttt{src}(x,y)}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
//        THRESH_TOZERO_INV = 4, //!< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
//        THRESH_MASK       = 7,
//        THRESH_OTSU       = 8, //!< flag, use Otsu algorithm to choose the optimal threshold value
//        THRESH_TRIANGLE   = 16 //!< flag, use Triangle algorithm to choose the optimal threshold value
//    };
}

