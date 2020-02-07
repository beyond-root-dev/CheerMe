//
//  RewardView.swift
//  CheerMe
//
//  Created by Admin on 1/21/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit

@IBDesignable public class RewardView: UIView {

    
    //MARK:- IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    
    //MARK:- Variables
    fileprivate var rootView : UIView!
    
    // MARK: - Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
        
        
        
//        let request = URLRequest.init(url: URL.init(string: "https://www.google.com")!)
//        webView.load(request)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        setupView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        setupView()
        
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        setupView()
    }
    
    // MARK: - Internal functions
    // MARK:
    
    // Setup the view appearance
    fileprivate func setupView(){
        
       
    }
    
    
    // MARK: - Xib file
    // MARK:
    fileprivate func xibSetup() {
        guard rootView == nil else { return }
        rootView = loadViewFromNib()
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView)
        
        let frameworkBundleID  = "org.cocoapods.CheerMe";
        let bundle = Bundle.init(identifier: frameworkBundleID)

//        let filePath = bundle!.path(forResource: "index", ofType: "html", inDirectory: "")
//        let html = try! String.init(contentsOfFile: filePath!)
//
//        webView.loadHTMLString(html, baseURL: URL.init(fileURLWithPath: bundle!.bundlePath+""))
        
//        let request = URLRequest.init(url: URL.init(fileURLWithPath: bundle!.bundlePath+"index.html?publicKey=8994acfe-22ac-4121-b4f7-9194456a59b4&customerId=102&customerToken=Customer_Token"))
        
        let request = URLRequest.init(url: URL.init(string: "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4142/?publicKey=8994acfe-22ac-4121-b4f7-9194456a59b4")!)
        
        webView.load(request)
        
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RewardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    @IBAction func btnOpenRewardsAction(_ sender: UIButton) {
    }
}
