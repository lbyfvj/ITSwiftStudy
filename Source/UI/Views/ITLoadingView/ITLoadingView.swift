//
//  ITLoadingView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITLoadingView: UIView {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var isVisible: Bool = false
    
    private let kITLoadingDuration: TimeInterval = 1
    private let kITAlpha: CGFloat = 0.5
    
    // MARK: -
    // MARK: Class Methods
    
    class func view(onSuperView superView: UIView) -> ITLoadingView {
        let view: ITLoadingView? = Bundle.object(withClass: type(of: self) as! AnyClass) as? ITLoadingView
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view?.frame = superView.bounds
        view?.alpha = 0.0
        
        return view!
    }
    
    // MARK: -
    // MARK: Accessors
    
//    func setVisible(_ visible: Bool) {
//        setVisible(visible, animated: false)
//    }
//    
//    func setVisible(_ visible: Bool, animated: Bool) {
//        setVisible(visible, animated: animated, completionHandler: nil)
//    }
    
    func setVisible(_ visible: Bool, animated: Bool, completionHandler block: @escaping (_ finished: Bool) -> Void) {
        superview?.bringSubview(toFront: self)
        UIView.animate(withDuration: animated ? kITLoadingDuration : 0, animations: {() -> Void in
            self.alpha = visible ? self.kITAlpha : 0.0
        }, completion: {(_ finished: Bool) -> Void in
            self.isVisible = visible
            block(finished)
        })
    }
    
}
