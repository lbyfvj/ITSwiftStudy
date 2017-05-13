//
//  ITLoadingView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITLoadingView: UIView {
    
    private let kITLoadingDuration: TimeInterval = 1
    private let kITAlpha: CGFloat = 0.5
    
    @IBOutlet public var spinner: UIActivityIndicatorView? {
        didSet {
            if spinner != oldValue {
                spinner.map(self.addSubview)
                oldValue?.removeFromSuperview()
            }
        }
    }
    
    private var _visible: Bool = true
    
    public var visible: Bool {
        get { return self._visible }
        set { self.set(visible: newValue, animated: true, completionHandler: {}) }
    }
    
    
    // MARK: -
    // MARK: Class Methods
    
    class func view(onSuperView superView: UIView) -> ITLoadingView {
        let view: ITLoadingView? = Bundle.object(with: self)
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view?.frame = superView.bounds
        view?.alpha = 0.0
        
        return view!
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
        set(visible: visible, animated: false)
    }
    
    func set(visible: Bool, animated: Bool) {
        set(visible: visible, animated: animated, completionHandler: {})
    }
    
    func set(visible: Bool, animated: Bool, completionHandler: () -> Void) {
        superview?.bringSubview(toFront: self)
        UIView.animate(
            withDuration: animated ? kITLoadingDuration : 0,
            animations: { self.alpha = visible ? self.kITAlpha : 0.0 },
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
