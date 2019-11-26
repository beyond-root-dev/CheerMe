//
//  CMFloatButton.swift
//  CheerMe
//
//  Created by Admin on 11/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@IBDesignable public class CMFloatButton: UIButton {

    let nibName = "CMFloatButton"
    var contentView: UIView!
    
    // MARK:- Set Up View
    public override init(frame: CGRect) {
     // For use in code
      super.init(frame: frame)
      setUpView()
    }

    public required init?(coder aDecoder: NSCoder) {
       // For use in Interface Builder
       super.init(coder: aDecoder)
      setUpView()
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        addSubview(contentView)
        
//        contentView.center = self.center
//        contentView.autoresizingMask = []
//        contentView.translatesAutoresizingMaskIntoConstraints = true
      
    }

}
