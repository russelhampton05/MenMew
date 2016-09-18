//
//  TestViewController.swift
//  Test_004_QRScanner
//
//  Created by Jon Calanio on 9/17/16.
//  Copyright © 2016 Jon Calanio. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    
    @IBOutlet var testButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        testButton.target = self.revealViewController()
        testButton.action = "revealToggle:"
        
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
