//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import SVPullToRefresh

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var isLoading = false
    var offset: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial setup of Search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "e.g, tacos, delivery, Max's"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 95
        tableView.addPullToRefresh(actionHandler: { [weak self] in
            self?.doNewSearch()
        })
        
        self.tableView.pullToRefreshView.arrowColor = UIColor(red: 0.82, green: 0.13, blue: 0.13, alpha: 1)
        self.tableView.pullToRefreshView.textColor = UIColor(red: 0.82, green: 0.13, blue: 0.13, alpha: 1)
        //        self.tableView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "down-arrow"))
        
        tableView.addInfiniteScrolling(actionHandler: { [weak self] in
            self?.doSearchWithOffset(self?.businesses?.count ?? 0, newSearch: false)
        })
        
        doNewSearch()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            if (businesses.count > 0) {
            return businesses.count
            }
            else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (businesses != nil && businesses.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
            cell.business = businesses[indexPath.row]
            return cell
            
        } else {
            self.tableView.pullToRefreshView.stopAnimating()
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            cell.textLabel?.text = !isLoading ? "No Results Found. Retry with a less restrictive filter" : ""
            self.tableView.pullToRefreshView.stopAnimating()
            return cell
        }
    }
    
    // MARK: - Searchbar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        Business.searchWithTerm(term: searchText, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses!
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        if (segue.identifier == "filterSegue")
        {
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
            
        }
        else if (segue.identifier == "mapSegue")
        {
            let mapViewController = navigationController.topViewController as! MapViewController
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: SearchSettings) {
        
        let sort = SearchSettings.sharedInstance.sort
        let deals = SearchSettings.sharedInstance.deals
        let distance = SearchSettings.sharedInstance.distance
        let categories = SearchSettings.sharedInstance.categories
        
        Business.searchWithTerm(term: "Restaurants",
                                sort: sort,
                                categories: categories,
                                deals: deals,
                                distance: distance,
                                offset: 0,  completion:
            { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
        })
    }
    
    fileprivate func doNewSearch() {
        doSearchWithOffset(0, newSearch: true)
    }
    
    fileprivate func doSearchWithOffset(_ offset: Int, newSearch: Bool) {
        
        isLoading = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        SearchSettings.sharedInstance.resetFiltersForNewSearch()
        Business.searchWithTerm(term: SearchSettings.sharedInstance.searchString, sort: SearchSettings.sharedInstance.sort, categories: SearchSettings.sharedInstance.categories, deals: SearchSettings.sharedInstance.deals, distance: SearchSettings.sharedInstance.distance, offset: offset,
                                completion: { (businesses: [Business]?, error: Error?) -> Void in
                                    
                                    if let businesses = businesses {
                                        if newSearch {
                                            self.businesses = businesses
                                            
                                        } else {
                                            for business in businesses {
                                                self.businesses.append(business)
                                            }
                                        }
                                        
                                    }
                                    
                                    self.isLoading = false
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.tableView.pullToRefreshView.stopAnimating()
                                    self.tableView.infiniteScrollingView.stopAnimating()
                                    self.tableView.reloadData()
        })
    }
    
    
}
