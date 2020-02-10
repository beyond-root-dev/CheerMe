//
//  FloatingButtonController.swift
//  CheerMe
//
//  Created by Admin on 2/4/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit

public class CheerMeController: UIViewController {

    var customerId:String!
    var customerToken:String!
    var publicKey:String!
    
    public var button: UIButton!
    public var rewardView:WKWebView!
    private let window = CheerMeWindow()
    private var activityIndicator:UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    public init(_ publicKey:String?, _ customerId:String?, _ customerToken:String?) {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
        
        if let custId = customerId {
            self.customerId = custId
        }
        if let pubKey = publicKey {
            self.publicKey = pubKey
        }
        if let custToken = customerToken {
            self.customerToken = custToken
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    override public func loadView() {
        let view = UIView()
        let button = UIButton(type: .custom)
        
//        let frameworkBundleID  = "org.cocoapods.CheerMe";
//        let bundle = Bundle.init(identifier: frameworkBundleID)
        button.setImage(UIImage.init(named: "plus", in: Bundle.init(for: CheerMeController.classForCoder()), compatibleWith: nil), for: .normal)
        
        button.setTitleColor(UIColor.green, for: .normal)
        button.backgroundColor = UIColor.clear

        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - button.bounds.size.width, y: UIScreen.main.bounds.height - button.bounds.size.height), size: button.bounds.size)
        button.autoresizingMask = []
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
        window.rewardView = nil
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
        button.addGestureRecognizer(panner)
        
        button.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonWasTapped() {
        self.loadView()
    }
    
    @objc func floatingButtonWasTapped() {
//        let bundle = Bundle(for: type(of: self))
//        let testVC = TestViewController(nibName: "TestViewController", bundle: bundle)
//        self.present(testVC, animated: true, completion:nil)
        
        let view = UIView.init()
        view.backgroundColor = .clear
        
        var cheerMeURL = URL.init(string: "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4142")
        if self.customerId == nil {
            cheerMeURL = URL.init(string: "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4142/?publicKey="+self.publicKey)
        }
        else {
            cheerMeURL = URL.init(string: "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4142/?publicKey="+self.publicKey+"&customerId="+self.customerId+"&customerToken="+self.customerToken)
        }
        
        let webView = WKWebView.init(frame: CGRect.init(x: (UIScreen.main.bounds.size.width-300)/2, y: (UIScreen.main.bounds.size.height-500)/2, width: 300, height: 500))
        let request = URLRequest.init(url: cheerMeURL!)
        
        webView.layer.shadowColor = UIColor.black.cgColor
        webView.layer.shadowRadius = 1
        webView.layer.shadowOpacity = 0.25
        webView.layer.shadowOffset = CGSize.zero
        webView.sizeToFit()
        webView.load(request)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: (webView.frame.size.width-100)/2, y: (webView.frame.size.height-100)/2, width: 100, height: 100))
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.startAnimating()
        
        webView.addSubview(activityIndicator)
        
        let cancelBtn = UIButton.init(type: .custom)
//        let frameworkBundleID  = "org.cocoapods.CheerMe";
//        let bundle = Bundle.init(identifier: frameworkBundleID)
        cancelBtn.setImage(UIImage.init(named: "close", in: Bundle.init(for: CheerMeController.classForCoder()), compatibleWith: nil), for: .normal)
        cancelBtn.frame = CGRect.init(x: webView.frame.size.width-30, y: 0, width: 30, height: 30)
        webView.addSubview(cancelBtn)
        self.view = view
        self.rewardView = webView
        window.rewardView = rewardView
        cancelBtn.addTarget(self, action: #selector(cancelButtonWasTapped), for: .touchUpInside)
        
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToSocket()
    }

    @objc func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var center = button.center
        center.x += offset.x
        center.y += offset.y
        button.center = center

        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }

    @objc func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }

    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = button.center
        for socket in sockets {
            let distance = hypot(center.x - socket.x, center.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        button.center = bestSocket
    }

    private var sockets: [CGPoint] {
        let buttonSize = button.bounds.size
        let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.midY)
        ]
        return sockets
    }

}

private class CheerMeWindow: UIWindow {

    var button: UIButton?
    var rewardView:WKWebView?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if let webView = rewardView {
            let webPoint = convert(point, to: rewardView)
            return webView.point(inside: webPoint, with: event)
        }
        else {
            guard let button = button else { return false }
            let buttonPoint = convert(point, to: button)
            return button.point(inside: buttonPoint, with: event)
        }
    }
    
}

extension CheerMeController:WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
}
