//
//  ToolbarWithDone.swift
//  done-toolbar-swift
//
//  Created by Bruno Henriques on 08/08/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import UIKit

open class ToolbarWithDone: UIToolbar {
    open var viewsWithToolbar: [UIView] = []
    
    fileprivate let DoneButtonHeight: CGFloat = 40.0
    fileprivate let DoneButtonWidth: CGFloat  = 100.0
    
    public init (viewsWithToolbar: [UIView]) {
        self.viewsWithToolbar = viewsWithToolbar
        super.init(frame: CGRect.zero)
        
        sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ToolbarWithDone.dismissInputView(_:)))
        items = [flexBarButton, doneBarButton]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func generateInputView(_ view: UIView, inputHeight: CGFloat = 200) -> UIView{
        let screenWidth = UIScreen.main.bounds.width
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: inputHeight + DoneButtonHeight))
        let inputViewSize = view.frame.size.width
        
        view.frame.origin.x = screenWidth*0.5 - inputViewSize*0.5
        inputView.addSubview(view)
        
        return inputView
    }
    
    internal func dismissInputView(_ sender: UIView){
        for v in viewsWithToolbar {
            v.endEditing(true)
        }
    }
}
