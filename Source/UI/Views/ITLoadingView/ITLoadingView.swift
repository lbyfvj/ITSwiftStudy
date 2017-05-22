//
//  ITLoadingView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITLoadingView: UIView {
    
    struct Animation {
        static let duration: TimeInterval = 1
        static let alpha: CGFloat = 1.0
    }
    
    @IBOutlet public var spinner: UIActivityIndicatorView? {
        didSet {
            if spinner != oldValue {
                spinner.map(self.addSubview)
                oldValue?.removeFromSuperview()
            }
        }
    }
    
    private var _visible: Bool = false
    
    public var visible: Bool {
        get { return self._visible }
        set { self.set(visible: newValue, animated: true, completionHandler: {}) }
    }
    
    
    // MARK: -
    // MARK: Class Methods
    
    class func view(onSuperView superView: UIView) -> ITLoadingView {
        let view = Bundle.object(type: self) ?? ITLoadingView.init(frame: superView.bounds)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame = superView.bounds
        view.alpha = 0.0
        
        return view
    }
    
    // MARK: -
    // MARK: Initializations and deallocations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        defer { self.setup() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    // MARK: -
    // MARK: Accessors
    
    func set(visible: Bool) {
        self.set(visible: visible, animated: true)
    }
    
    func set(visible: Bool, animated: Bool) {
        self.set(visible: visible, animated: animated, completionHandler: {})
    }
    
    func set(visible: Bool, animated: Bool, completionHandler: () -> Void) {
        self.superview?.bringSubview(toFront: self)
        UIView.animate(
            withDuration: animated ? Animation.duration : 0,
            animations: { self.alpha = visible ? Animation.alpha : 0.0 },
            completion: { _ in self._visible = visible }
        )
    }
    
    // MARK: -
    // MARK: Private
    
    private func setup() {
        if self.spinner == nil {
            let spinner = UIActivityIndicatorView(frame: self.bounds)
            spinner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.spinner = spinner
        }
    }
    
}
