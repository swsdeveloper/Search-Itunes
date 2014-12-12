//
//  iTunesData.swift
//  class4 hw
//
//  Created by Steven Shatz on 7/26/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

import UIKit


// See: "http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html#searching"


class ItunesObject {
  
  var urlPathPrefix: String?
  var urlPathSuffix: String?
  
  var nameKey: String?
  var imageUrlKey: String?

  init() {
    
    var str1 = ""
    var str2 = ""
    var str3 = ""
    
    // To search for albums:
    //----------------------
    str1 = "&media=music&entity=album"
    str2 = "&limit=100"  //limit defaults to 50; can be 1-200
    str3 = "collectionCensoredName"
  
    // To search for ebooks:
    //----------------------
    //str1 = "&media=ebook&entity=ebook"
    //str2 = "&limit=100"  //limit defaults to 50; can be 1-200
    //str3 = "trackCensoredName"
    
    // To search for iOS apps - very slow to load:
    //--------------------------------------------
    //str1 = "&media=software&entity=iPadSoftware"
    //str2 = ""
    //str3 = "trackCensoredName"
    
    self.urlPathPrefix = "https://itunes.apple.com/search?term="
    self.urlPathSuffix = str1 + str2

    self.nameKey = str3
    self.imageUrlKey = "artworkUrl100"
  }
  
}

