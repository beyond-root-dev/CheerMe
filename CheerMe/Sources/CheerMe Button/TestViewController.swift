//
//  TestViewController.swift
//  CheerMe
//
//  Created by Admin on 2/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
    @IBAction func btnClose(_ sender: UIButton) {
        print("Cancel Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
}
