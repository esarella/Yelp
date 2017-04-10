//
//  CustomCell.swift
//  Yelp
//
//  Created by Emmanuel Sarella on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func customCell(customCell: CustomCell, didChangeValue value: Bool)
}

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: CustomButton!
    
    weak var delegate: CustomCellDelegate?
    
    func switchValueChange(_ sender: CustomButton) {
        sender.buttonClicked(sender: sender)
        delegate?.customCell(customCell: self, didChangeValue: onSwitch.isChecked)
    }
    
    func resetButton() {
        onSwitch.isChecked = false
    }
    
    func buttonIsChecked() -> Bool {
        return onSwitch.isChecked
    }
    
}
