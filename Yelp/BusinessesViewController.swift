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

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    var searchBar: UISearchBar!

    
    // Infinite loading variables
    var isLoading = false
    var offset: Int = 0
    var limit: Int = 20 // Default Yelp limit
    
    
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
        doNewSearch()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 95

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    // MARK: - Searchbar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        Business.searchWithTerm(term: searchText, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses!
            self.tableView.reloadData()
//            if let businesses = businesses
//                            for business in businesses {
//                                print(business.name!)
//                                print(business.address!)
//                            }
//            }
            
        })
    }
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
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
            self.businesses = businesses!
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
                                            
                                            for business in businesses {
//                                                let coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude)
//                                                self.addAnnotationAtCoordinate(coordinate, title: business.name, address: business.address)
                                            }
                                            
                                        } else {
                                            for business in businesses {
                                                self.businesses.append(business)
//                                                let coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude)
//                                                self.addAnnotationAtCoordinate(coordinate, title: business.name, address: business.address)
                                            }
                                        }
                                        
                                        self.tableView.reloadData()
                                    }
                                    
                                    self.isLoading = false
                                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
        })
    }

    
}
