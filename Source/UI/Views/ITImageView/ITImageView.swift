//
//  ITImageView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITImageView: ITView {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var contentImageView: UIImageView! {
        willSet {
            
        }
        
        didSet {
            self.addSubview(contentImageView)
        }
    }
    
    var imageModel: ITImageModel? {
        willSet {
            self.spinner.startAnimating()
        }
        
        didSet {
            self.spinner.stopAnimating()
        }
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubviews()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initSubviews()
    }
    
    func initSubviews() {
        let imageView = UIImageView(frame: bounds)
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleHeight]
        self.contentImageView = imageView
    }
    
    // MARK: -
    // MARK: Accessors
    
}
