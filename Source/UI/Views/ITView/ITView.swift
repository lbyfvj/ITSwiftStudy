//
//  ITView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITView: UIView {
    
    var loadingView: ITLoadingView?
    var loadingViewVisible: Bool = false
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadingView = self.initialLoadingView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.loadingView = self.initialLoadingView()
    }
    
    // MARK: -
    // MARK: Accessors
    
    func set(loadingViewVisible: Bool) {
        self.loadingView?.visible = loadingViewVisible
    }
    
    func isLoadingViewVisible() -> Bool {
        return self.loadingView!.visible
    }
    
    // MARK: -
    // MARK: Public
    
    func initialLoadingView() -> ITLoadingView {
        return ITLoadingView.view(onSuperView: self)
    }

}
