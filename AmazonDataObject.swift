//
//  AmazonDataObject.swift
//  class4 hw
//
//  Created by Steven Shatz on 7/27/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

import Foundation

class AmazonDataObject {
  
  var urlPathPrefix: String?
  var urlPathSuffix: String?
  
  var albumNameKey: String?
  var imageUrlKey: String?
  
  init() {
    self.urlPathPrefix = "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords="
    self.urlPathSuffix = "+album"
    self.albumNameKey = "collectionCensoredName"
    self.imageUrlKey = "artworkUrl100"
  }
  
}