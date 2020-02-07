//
//  RoundShadowView.swift
//  CheerMe
//
//  Created by Admin on 12/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable public class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    @IBInspectable private var cornerRadius: CGFloat = 15.0
    @IBInspectable private var shadowOpacity: Float = 0.2
    @IBInspectable private var shadowRadius: CGFloat = 3
    @IBInspectable private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    @IBInspectable private var shadowColor: UIColor = .black
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
//            shadowLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
