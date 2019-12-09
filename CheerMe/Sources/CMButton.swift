//
//  CMButton.swift
//  CheerMe
//
//  Created by Admin on 11/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

//import UIKit
//
//@IBDesignable open class CMButton: UIControl {
//
//    // MARK: - IBOutlets
//    @IBOutlet weak var imageView: UIImageView!
//
//
//    fileprivate var rootView : UIView!
//    
//    // MARK: - Inspectable properties
//    @IBInspectable public var buttonImage: UIImage? {
//        didSet{
//            setupView()
//        }
//    }
//
//    // Setup the view appearance
//    fileprivate func setupView(){
//        setupImage()
//    }
//
//    fileprivate func setupImage() {
//        self.imageView.image = buttonImage
//    }
//
//
//    // MARK: - Overrides
//    // MARK:
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        xibSetup()
//        setupView()
//    }
//
//    required public init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        xibSetup()
//        setupView()
//    }
//
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//        xibSetup()
//        setupView()
//    }
//
//    override open func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        xibSetup()
//        setupView()
//    }
//
//
//    // MARK: - Xib file
//    // MARK:
//    fileprivate func xibSetup() {
//        guard rootView == nil else { return }
//        rootView = loadViewFromNib()
//        rootView.frame = bounds
//        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(rootView)
//
//    }
//
//    fileprivate func loadViewFromNib() -> UIView {
//
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "CMButton", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//
//        return view
//    }
//
//    //MARK:- IBAction
//    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
//    }
//
//
//}


import UIKit
import QuartzCore


@IBDesignable open class CMButton: UIControl {
    
    
    fileprivate var rootView : UIView!
    @IBOutlet weak var imageView: UIImageView?
    
    // MARK: - Inspectable properties
    // MARK:
    
    @IBInspectable public var image: UIImage? {
        didSet{
            setupView()
        }
    }
    
    // MARK: - Overrides
    // MARK:
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
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
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        setupImageView()
    }
    
    fileprivate func setupImageView() {
//        self.imageView!.image = image
    }
    
    
    // MARK: - Xib file
    // MARK:
    fileprivate func xibSetup() {
        guard rootView == nil else { return }
        rootView = loadViewFromNib()
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CMButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    
    @IBAction func tapAction(_ sender: Any) {
        
        print("Button tapped")
        
        sendActions(for: .touchUpInside)
        let frameworkBundleID  = "com.framework.cheerMe";
        let bundle = Bundle.init(identifier: frameworkBundleID)
        let welcomeVC = WelcomeVC(nibName: "WelcomeVC", bundle: bundle)
        UIApplication.shared.keyWindow?.rootViewController?.present(welcomeVC, animated: true, completion: nil)
    }
}
