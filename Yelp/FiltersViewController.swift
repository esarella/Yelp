//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Emmanuel Sarella on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: SearchSettings)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!

    var switchStates = [Int: Bool]()
    weak var delegate: FiltersViewControllerDelegate?

    // List variables
    var categories: [[String: String]]!
    var distances: [[String: AnyObject]]!
    var sorts: [[String: AnyObject]]!

    // State variables
    var deals: Bool = false
    var distanceStates: [Int: Bool] = [0: true]
    // Default to Auto
    var sortStates: [Int: Bool] = [0: true]
    // Default to Best Matched
    var categoryStates: [Int: Bool] = [:]

    // Expand variables
    var distanceExpanded: Bool = false
    var sortExpanded: Bool = false
    var categoriesExpanded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        distances = SearchSettings.distanceOptions()
        sorts = SearchSettings.sortOptions()
        categories = SearchSettings.yelpCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SearchSettings.sharedInstance.resetFiltersForNewSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancel(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }


    @IBAction func onSearch(_ sender: Any) {
        // Deals
        SearchSettings.sharedInstance.deals = deals

        // Sort
        SearchSettings.sharedInstance.sort = YelpSortMode.bestMatched
        for (row, isSelected) in sortStates {
            if isSelected {
                SearchSettings.sharedInstance.sort = sorts[row]["sort"] as! YelpSortMode
                break
            }
        }

        // Distance
        SearchSettings.sharedInstance.distance = maxDistance
        for (row, isSelected) in distanceStates {
            if isSelected {
                SearchSettings.sharedInstance.distance = distances[row]["meters"] as! Double
                break
            }
        }

        // Categories
        var selectedCategories = [String]()
        for (row, isSelected) in categoryStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }

        if selectedCategories.count > 0 {
            SearchSettings.sharedInstance.categories = selectedCategories
        }

        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: SearchSettings.sharedInstance)
        dismiss(animated: true, completion: nil)

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FilterSection(rawValue: section)! {
        case FilterSection.distance:
            return distanceExpanded ? distances.count : 1
        case FilterSection.sort:
            return sortExpanded ? sorts.count : 1
        case FilterSection.categories:
            return categoriesExpanded ? categories.count : 5
        case FilterSection.deals:
            return 1
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FilterSection(rawValue: indexPath.section)! {
        case FilterSection.deals:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.isOn = false
            return cell

        case FilterSection.distance:
            if !distanceExpanded && 0 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                for (row, isSelected) in distanceStates {
                    if isSelected {
                        cell.expandableCellLabel.text = distances[row]["name"] as? String
                        break
                    }
                }
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
            cell.switchLabel.text = distances[indexPath.row]["name"] as? String
//            cell.onSwitch.isChecked = distanceStates[indexPath.row] ?? false
            cell.delegate = self
            cell.onSwitch.isOn = distanceStates[indexPath.row] ?? false
            return cell

        case FilterSection.sort:
            if !sortExpanded && 0 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                for (row, isSelected) in sortStates {
                    if isSelected {
                        cell.expandableCellLabel.text = sorts[row]["name"] as? String
                        break
                    }
                }
                return cell
            }

//            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = sorts[indexPath.row]["name"] as? String
            cell.delegate = self
//            cell.onSwitch.isChecked = sortStates[indexPath.row] ?? false
            cell.onSwitch.isOn = sortStates[indexPath.row] ?? false
            return cell

        case FilterSection.categories:
            if !categoriesExpanded && 4 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllCell", for: indexPath)
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = categoryStates[indexPath.row] ?? false
            return cell
        }
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch FilterSection(rawValue: section)! {
        case FilterSection.distance:
            return "Distance"
        case FilterSection.sort:
            return "Sort By"
        case FilterSection.categories:
            return "Category"
        default: // FilterSection.deals
            return " "
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!

        switch FilterSection(rawValue:indexPath.section)! {
        case FilterSection.deals:
            deals = value

        case FilterSection.distance:
            distanceStates = [:] // Reset distance states
            distanceStates[indexPath.row] = value
            distanceExpanded = false
            tableView.reloadSections(NSIndexSet(index: FilterSection.distance.rawValue) as IndexSet, with: .none)

        case FilterSection.sort:
            sortStates = [:] // Reset sort states
            sortStates[indexPath.row] = value
            sortExpanded = false
            tableView.reloadSections(NSIndexSet(index: FilterSection.sort.rawValue) as IndexSet, with: .none)

        case FilterSection.categories:
            categoryStates[indexPath.row] = value
        }
    }
    
//    func customCell(customCell: CustomCell, didChangeValue value: Bool) {
//        let indexPath = self.tableView.indexPath(for: customCell)!
//
//        switch FilterSection(rawValue:indexPath.section)! {
//            case FilterSection.deals:
//            deals = value
//
//            case FilterSection.distance:
//            distanceStates = [:] // Reset distance states
//            distanceStates[indexPath.row] = value
//            distanceExpanded = false
//            tableView.reloadSections(NSIndexSet(index: FilterSection.distance.rawValue) as IndexSet, with: .none)
//
//            case FilterSection.sort:
//            sortStates = [:] // Reset sort states
//            sortStates[indexPath.row] = value
//            sortExpanded = false
//            tableView.reloadSections(NSIndexSet(index: FilterSection.sort.rawValue) as IndexSet, with: .none)
//
//            case FilterSection.categories:
//            categoryStates[indexPath.row] = value
//            }
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if " " != self.tableView(tableView, titleForHeaderInSection: section) {
            return 45
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = self.tableView(tableView, cellForRowAt: indexPath)
        if "SeeAllCell" == cell.reuseIdentifier {
            categoriesExpanded = true
            tableView.reloadSections(NSIndexSet(index: FilterSection.categories.rawValue) as IndexSet, with: .none)
            
        } else if "ExpandableCell" == cell.reuseIdentifier {
            switch FilterSection(rawValue:indexPath.section)! {
            case FilterSection.distance:
                distanceExpanded = true
                tableView.reloadSections(NSIndexSet(index: FilterSection.distance.rawValue) as IndexSet, with: .none)
            case FilterSection.sort:
                sortExpanded = true
                tableView.reloadSections(NSIndexSet(index: FilterSection.sort.rawValue) as IndexSet, with: .none)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard nil != self.tableView(tableView, titleForHeaderInSection: section) else {
            return nil
        }
        
        let headerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: 45)))
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.width, height: 30))
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.addSubview(label)
        return headerView
    }

}
