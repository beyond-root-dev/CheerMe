//
//  WelcomeVC.swift
//  CheerMe
//
//  Created by Admin on 12/5/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IBActions
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
