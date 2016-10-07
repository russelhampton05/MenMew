//
//  QRViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/15/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import AVFoundation

//Placeholder structs (will be replaced with actual models)
struct MenuItem {
    var title: String
    var price: Double
    var image: String
    var desc: String
}

struct Details {
    var sides: [String]
    var cookType: [String]
}

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let transition = CircleTransition()
    var flag: Bool = true
    
    var appID: String?
    var restaurantTitle: String?
    var location: String?
    var tableNum: Int?
    var connectionURL: URL?
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.isNavigationBarHidden = true
    
        
        super.viewDidLoad()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //Variables for QR Code Capture
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    
    
    //Configuration function
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error : NSError?
        
        let objCaptureDeviceInput : AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        }
        catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        
        //UIAlertController
        if error != nil {
            let alertView = UIAlertController(title: "Device Error", message: "Device is not supported for this application.", preferredStyle: .alert)
            alertView.show(self, sender: Any.self)
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    	
    //Video Preview Layer
    func addVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
        videoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        self.view.bringSubview(toFront: titleLabel)
        self.view.bringSubview(toFront: messageLabel)
    }
    
    //Video Preview Layer Orientation Transitions
    override func viewWillLayoutSubviews() {
        
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        print(orientation)
        
        switch (orientation) {
        case .portrait:
            videoPreviewLayer?.connection.videoOrientation = .portrait
            videoPreviewLayer?.frame = view.layer.bounds
        case .landscapeRight:
            videoPreviewLayer?.connection.videoOrientation = .landscapeLeft
            videoPreviewLayer?.frame = view.layer.bounds
        case .landscapeLeft:
            videoPreviewLayer?.connection.videoOrientation = .landscapeRight
            videoPreviewLayer?.frame = view.layer.bounds
        default:
            videoPreviewLayer?.connection.videoOrientation = .portrait
            videoPreviewLayer?.frame = view.layer.bounds
        }
    }
    
    //Initialize QR Code View
    func initializeQRView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
        qrCodeFrameView?.layer.borderWidth = 5
        self.view.addSubview(qrCodeFrameView!)
        self.view.bringSubview(toFront: qrCodeFrameView!)
    }
    
    
    //Capture delegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR Code detected"
            return
        }
        
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = videoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                

                //JSON loading and parsing can be done here
                messageLabel.text = objMetadataMachineReadableCodeObject.stringValue
                
                if flag {
                    //Initiate segue to loading screen
                    flag = false
                    startConnection()
                    qrCodeFrameView!.removeFromSuperview()
                    videoPreviewLayer!.removeFromSuperlayer()
                    captureSession!.stopRunning()

                    performSegue(withIdentifier: "MenuLoadSegue", sender: self)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuLoadVC = segue.destination as! RestaurantViewController
        

        menuLoadVC.connectionURL = connectionURL
    }
    
    
    //JSON Loading Function
    func loadJSON() {
        
        //Load the URL
        startConnection()

        URLSession.shared.dataTask(with: connectionURL!, completionHandler: {(data, response, error) in
            if error != nil {
                //Error
                print(error)
            } else {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: Any]
                    
                    if let appIdentifier = jsonData["application"] as? String {
                        self.appID = appIdentifier
                    }
                    
                    if let restaurantName = jsonData["name"] as? String {
                        self.restaurantTitle = restaurantName
                    }
                    
                    if let restaurantLocation = jsonData["location"] as? String {
                        self.location = restaurantLocation
                    }
                    
                    if let restaurantTableNum = jsonData["table"] as? Int {
                        self.tableNum = restaurantTableNum
                    }
                    
                    self.verifyMenu()
                    
                } catch let error as NSError {
                    //Error
                    print(error)
                }
            }
        }).resume()
    }
    
    func startConnection() {
        let urlPath = messageLabel.text
        connectionURL = NSURL(string: urlPath!) as URL?
    }
    
    func verifyMenu() {
        //Conditional to check for valid objects
        if appID == "MenMew" {
            qrCodeFrameView!.removeFromSuperview()
            videoPreviewLayer!.removeFromSuperlayer()
            captureSession!.stopRunning()
            
            performSegue(withIdentifier: "MenuLoadSegue", sender: self)
        }
    }
}
