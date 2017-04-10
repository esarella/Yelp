//
//  SwitchCell.swift
//  Yelp
//
//  Created by Emmanuel Sarella on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    @IBAction func switchValueChange(_ sender: Any) {
            delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
        }
}
