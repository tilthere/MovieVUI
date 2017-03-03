//
//  Models.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/16/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit

//    let images = ["the edge of seventeen", "arrival", "doctor strange", "the take", "trolls", "pete's dragon", "almost christmas", "finding dory", "the secret life of pets"]


class Movie: NSObject {
    var id: String?
    var title: String?
    var descriptn: String?
    var genres:[String]?
    var showtimes: [Showtime]?
    var image: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "showtimes" {
            
            showtimes = [Showtime]()
            for dict in value as! [[String: AnyObject]] {
                let showtime = Showtime()
                showtime.setValuesForKeys(dict)
                showtimes?.append(showtime)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }


}




class Showtime : NSObject {
    var theatre : Theatre?
    var dateTime: NSDate?
}


class Theatre : NSObject {
    var id: String?
    var name: String?
    var address: String?
    var city: String?
    var state:String?
    var zip: String?
    
}


class SearchResults: NSObject {
    var theatres = [Theatre]()
    var movies = [Movie]()
}


class Ticket: NSObject{
    var time: String?
    var date: [String]?
    var movieID: String?
    var theatreID: [String]?
    
}

