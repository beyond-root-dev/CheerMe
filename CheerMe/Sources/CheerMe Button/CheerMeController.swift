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
    var widgetURL = "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4242/api/Public/Widget/Get"
    var launcherColor = ""
    var launcherUrl = ""
    var launcherImage:UIImage!
    var laucherPlacement = 0
    
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
        
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "http://ec2-35-154-186-154.ap-south-1.compute.amazonaws.com:4242/api/Public/Widget/Get")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let custId = customerId {
            request.addValue(custId, forHTTPHeaderField: "CustomerId")
        }
        request.addValue(self.publicKey, forHTTPHeaderField: "PublicKey")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options : []) as? [String: Any]
                {
                    //                    print(jsonDict) // use the json here
                    let dataDict = jsonDict["Data"] as! [String:Any]
                    let widgetThemes = dataDict["WidgetThemes"] as! [String:Any]
                    let widgetLayouts = dataDict["WidgetLayouts"] as! [String:Any]
                    
                    self.launcherColor = widgetThemes["LauncherColor"] as! String
                    self.launcherUrl = widgetLayouts["LauncherIconURL"] as! String
                    
                    URLSession.shared.dataTask(with: URL.init(string: self.launcherUrl)!) { data, response, error in
                        guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data)
                            else { return }
                            self.launcherImage = image
                        
                        self.loadViewAfterResponse()
                        
                    }.resume()
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        
    }
    
    
    public func loadViewAfterResponse() {
        let view = UIView()
        let button = UIButton(type: .custom)
        
        //        let frameworkBundleID  = "org.cocoapods.CheerMe";
        //        let bundle = Bundle.init(identifier: frameworkBundleID)
        //        button.setImage(UIImage.init(named: "plus", in: Bundle.init(for: CheerMeController.classForCoder()), compatibleWith: nil), for: .normal)
        
        button.imageEdgeInsets = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        button.setImage(launcherImage, for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.backgroundColor = UIColor.init(hex: launcherColor)
        
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height), size: CGSize.init(width: 60, height: 60))
        button.autoresizingMask = []
        button.layer.cornerRadius = button.frame.size.height/2
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
        window.rewardView = nil
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
        button.addGestureRecognizer(panner)
        
        button.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
        
        snapButtonToSocket()
    }
    
    @objc func cancelButtonWasTapped() {
        self.loadViewAfterResponse()
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}
