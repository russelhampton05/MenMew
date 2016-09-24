//
//  QRViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/15/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let transition = CircleTransition()
    var flag: Bool = true
    
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
        
        //UIAlertView is deprecated so this can change
        if error != nil {
            let alertView : UIAlertView = UIAlertView(title: "Device error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Okay")
            alertView.show()
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
                
                //This is where we can retrieve the data, for now it just presents the URL for URL QR Codes
                //JSON parsing can be done here
                messageLabel.text = objMetadataMachineReadableCodeObject.stringValue
                
                if flag {
                    //Conditional to check for valid objects
                    if messageLabel.text == "RJ's Steakhouse" {
                        flag = false
                        qrCodeFrameView!.removeFromSuperview()
                        videoPreviewLayer!.removeFromSuperlayer()
                        captureSession!.stopRunning()
                        performSegue(withIdentifier: "MenuLoadSegue", sender: self)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as! RestaurantViewController
        
        newVC.restaurant = messageLabel.text
        newVC.tableNum = "Table 4"
    }
}
