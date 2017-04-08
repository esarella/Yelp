//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    //    var filteredBusinnesses: [Business]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 95
        
        let searchBar = UISearchBar.init()
        searchBar.placeholder = "e.g, tacos, delivery, Max's"
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                //                self.filteredBusinnesses = businesses
                self.tableView.reloadData()
                
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            
        }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
        
        
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
            
            self.businesses = businesses
            if let businesses = businesses {
                self.tableView.reloadData()
                
                //                            for business in businesses {
                //                                print(business.name!)
                //                                print(business.address!)
                //                            }
            }
            
        }
        )
    }
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as! [String]
        
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: Error!) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
    
}
