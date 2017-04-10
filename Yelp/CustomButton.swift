//
//  CustomButton.swift
//  Yelp
//
//  Created by Emmanuel Sarella on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    let buttonOnState = #imageLiteral(resourceName: "onButton")
    let buttonOffState = #imageLiteral(resourceName: "offButton")
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true{
                self.setImage(buttonOnState, for: .normal)
            }
            else {
                self.setImage(buttonOffState, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }

}
