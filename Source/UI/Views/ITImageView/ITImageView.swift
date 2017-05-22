//
//  ITImageView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITImageView: ITView {
    
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    @IBOutlet var contentImageView: UIImageView? {
        willSet { contentImageView?.removeFromSuperview() }
        didSet { contentImageView.map(self.addSubview) }
    }
    
    var imageModel: ITImageModel? {
        willSet {
            self.contentImageView?.image = nil
            
            DispatchQueue.main.async { self.spinner?.startAnimating() }
        }
        
        didSet {
            imageModel?.performLoading() {
                DispatchQueue.main.async {
                    self.contentImageView?.image = self.imageModel?.image ?? UIImage(named: Constants.Default.defaultImageName)
                    self.spinner?.stopAnimating()
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    deinit {
        self.contentImageView = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !self.contentImageView.boolValue {
            self.initSubviews()
        }
    }
    
    func initSubviews() {
        let imageView = UIImageView(frame: bounds)
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        
        self.contentImageView = imageView
    }
}
