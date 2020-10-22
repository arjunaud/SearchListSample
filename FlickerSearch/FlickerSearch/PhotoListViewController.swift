//
//  ViewController.swift
//  FlickerSearch
//
//  Created by Arjuna on 3/2/20.
//  Copyright © 2020 Arjuna. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoListViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource, PhotoListViewProtocol {


    @IBOutlet weak var listView: UITableView!
    
    var searchController = UISearchController()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var photoListViewModel:PhotoListViewModel!

    //var searchText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
        KingfisherManager.shared.downloader.downloadTimeout = 60


        
        photoListViewModel = PhotoListViewModel(view: self)
           
       if UIDevice.current.userInterfaceIdiom == .pad {
           photoListViewModel.pageSize = 50
       } else if UIDevice.current.userInterfaceIdiom == .phone {
           photoListViewModel.pageSize = 30
       }
       photoListViewModel.viewDidLoad()
       //photoListViewModel.searchText = "abcdefg"

        
        self.searchController =  UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.listView.tableHeaderView = self.searchController.searchBar
        

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 108
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoListViewModel.numberOfPhotoItemModels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photoItemViewModel = photoListViewModel.photoItemViewModelAtIndex(index: indexPath.item)
        let photoListViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoListViewCell
        photoListViewCell.setUpWith(photoItemModel: photoItemViewModel)
        return photoListViewCell
    }

    //UISearch result update delegate
     func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        photoListViewModel.searchText = searchText
    }
    
    func reloadPhotos() {
        self.listView.reloadData()
    }
    
    func showLoadingIndictor() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }



}

