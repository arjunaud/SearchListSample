//
//  PhotoService.swift
//  FlickerSearch
//
//  Created by Arjuna on 3/2/20.
//  Copyright © 2020 Arjuna. All rights reserved.
//

import Foundation

struct Photo {
    
    let owner:String
    let server:String
    let secret:String
    let farm:Int
    let title:String
//    let ispublic:Int?
//    let isfriend:Int?
//    let isfamily:Int?
    let id:String
    
    init(dict:Dictionary<String, Any>)
    {
        self.owner = dict["owner"] as! String
        self.server = dict["server"] as! String
        self.secret = dict["secret"] as! String
        self.farm = dict["farm"] as! Int
        self.title = dict["title"] as! String
        self.id = dict["id"] as! String
    }
}

protocol PhotoServiceProtocol {
    func fetchPhotoList(text:String, pageNumber:Int, limit:Int, completion: @escaping (_ photos:[Photo]?,_ pages:Int,_ total:Int, _ error:Error?)->(Void))
}

class PhotoServiceProvider:PhotoServiceProtocol {

        
    func fetchPhotoList(text:String, pageNumber: Int, limit: Int, completion: @escaping ([Photo]?, Int, Int, Error?) -> (Void)) {
        let urlString = "https://api.flickr.com/services/rest?method=flickr.photos.search&api_key=062a6c0c49e4de1d78497d13a7dbb360&text=\(text)&format=json&nojsoncallback=1&page=\(pageNumber)&per_page=\(limit)"
        let url = URL(string: urlString)!
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var photos:[Photo]? = []
            
            var jsonResponseDict:[String:Any]? = nil
            
            jsonResponseDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
            var totalPageCount = 0
            var totalPhotoCount = 0

            if jsonResponseDict != nil {
                totalPageCount = (jsonResponseDict!["photos"] as! Dictionary<String, Any>)["pages"] as! Int
                //totalPhotoCount = (jsonResponseDict!["photos"] as! Dictionary<String, Any>)["total"] as! Int
                
                if let photosArray = (jsonResponseDict!["photos"] as! Dictionary<String, Any>)["photo"] as? [Dictionary<String, Any>] {
                    
                    for photoDict in photosArray {
                            photos?.append(Photo(dict: photoDict))
                    }
                }
            }
                
            completion(photos,totalPageCount, totalPhotoCount, error)
        }.resume()
    }
}
