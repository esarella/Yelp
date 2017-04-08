//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Emmanuel Sarella on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    weak var delegate: FiltersViewControllerDelegate?
    
    var sections = [
        Section(title: "Deals", items: Section.dealOptions()),
        Section(title: "Distance", items: Section.buildDistanceOptions(), selectionMode: .single),
        Section(title: "Sort by", items: Section.buildSortOptions(), selectionMode: .single),
        Section(title: "Category", items: Section.buildCategories(), collapsed: false, minCollapsedItems: 3)
    ]
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String:AnyObject]()
        
        var selectedCategories = [String]()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.switchLabel.text = sections[indexPath.section].items[indexPath.row]["name"] as? String
        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }
    
}
