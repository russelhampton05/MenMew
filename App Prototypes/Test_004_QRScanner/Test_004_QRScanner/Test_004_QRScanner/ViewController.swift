//
//  ViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/15/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }
    
    
    //Variables for QR Code Capture
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    
    
    //Configuration function
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
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
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    	
    //Video Preview Layer
    func addVideoPreviewLayer() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
        videoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        self.view.bringSubviewToFront(titleLabel)
        self.view.bringSubviewToFront(messageLabel)
    }
    
    //Video Preview Layer Orientation Transitions
    override func viewWillLayoutSubviews() {
        
        let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        print(orientation)
        
        switch (orientation) {
        case .Portrait:
            videoPreviewLayer?.connection.videoOrientation = .Portrait
            videoPreviewLayer?.frame = view.layer.bounds
        case .LandscapeRight:
            videoPreviewLayer?.connection.videoOrientation = .LandscapeLeft
            videoPreviewLayer?.frame = view.layer.bounds
        case .LandscapeLeft:
            videoPreviewLayer?.connection.videoOrientation = .LandscapeRight
            videoPreviewLayer?.frame = view.layer.bounds
        default:
            videoPreviewLayer?.connection.videoOrientation = .Portrait
            videoPreviewLayer?.frame = view.layer.bounds
        }
    }
    
    //Initialize QR Code View
    func initializeQRView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.redColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 5
        self.view.addSubview(qrCodeFrameView!)
        self.view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    
    //Capture delegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR Code detected"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                
                //This is where we can retrieve the data, for now it just presents the URL for URL QR Codes
                //JSON parsing is possible here
                messageLabel.text = objMetadataMachineReadableCodeObject.stringValue
            }
        }
    }
    
}
