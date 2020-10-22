//
//  PhotoListViewModel.swift
//  FlickerSearch
//
//  Created by Arjuna on 3/2/20.
//  Copyright © 2020 Arjuna. All rights reserved.
//

import Foundation

class PhotoItemViewModel {
    let photo:Photo
    
    init(photo:Photo) {
        self.photo = photo
    }

    
    var title:String {
        return photo.id + " " + photo.title
    }
    
    func downloadUrl() -> String {
        return "https://farm\(self.photo.farm).staticflickr.com/\(self.photo.server)/\(self.photo.id)_\(self.photo.secret)_m.jpg"
    }
}

protocol PhotoListViewProtocol:class {
    func reloadPhotos()
    func showLoadingIndictor()
    func hideLoadingIndicator()
}

class PhotoListViewModel {
    weak var view:PhotoListViewProtocol?
    
    var photoListDataProvider = PhotoServiceProvider()
    var pageSize = 30
    var totalPageCount = 0
    var totalImageCount = 0
    
    var searchText: String = "" {
    
        didSet {
            if oldValue != self.searchText {
                self.photoItemViewModels.removeAll()
                self.view?.reloadPhotos()
                self.fetchPhotos(text: searchText, page: 1, self.pageSize)
            }
        }
    }
    
    private var photoItemViewModels:[PhotoItemViewModel] = []
    private var requestInProgress = false
    
    init(view:PhotoListViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        self.view?.showLoadingIndictor()
        self.fetchPhotos(text:"", page: 1, pageSize)
    }
    
    func numberOfPhotoItemModels() -> Int {
        return photoItemViewModels.count
    }
    
    func photoItemViewModelAtIndex(index:Int) -> PhotoItemViewModel {
        fetchNextPagePhotosIfNeeded(index)
        return self.photoItemViewModels[index]
    }
    
    private func fetchNextPagePhotosIfNeeded(_ currentRequestedIndex:Int) {
        
        if currentRequestedIndex == (self.photoItemViewModels.count - 1) {
            self.view?.showLoadingIndictor()
        }
        
        if (requestInProgress) {
            return
        }
        
        let lastFetchedPage = (self.photoItemViewModels.count / pageSize)
        let currentIndexPage = (currentRequestedIndex / pageSize) + 1
        
        if currentIndexPage <= totalPageCount && currentIndexPage >= lastFetchedPage {
            fetchPhotos(text:"", page: lastFetchedPage + 1, pageSize)
        }
    }
    
    private func fetchPhotos(text:String, page:Int, _ limit:Int) {
        if self.searchText.isEmpty {
            self.view?.hideLoadingIndicator()
            return
        }
        
        requestInProgress = true
        photoListDataProvider.fetchPhotoList(text: searchText,pageNumber:page, limit: pageSize) { [weak self] (photos, pages, total, error) -> (Void)  in
            
            if let strongSelf = self {
                if let photos = photos {
                    let photoItemViewModels = photos.map({ (photo) -> PhotoItemViewModel in
                        let photoItemViewModel = PhotoItemViewModel(photo: photo)
                        return photoItemViewModel
                    })
                    DispatchQueue.main.async {
                       strongSelf.requestInProgress = false
                       strongSelf.totalPageCount = pages
                       strongSelf.photoItemViewModels.append(contentsOf: photoItemViewModels)
                       strongSelf.view?.reloadPhotos()
                       strongSelf.view?.hideLoadingIndicator()
                    }
                }
            }
        }
    }
}
