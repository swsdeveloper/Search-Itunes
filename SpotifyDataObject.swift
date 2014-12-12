//
//  SpotifyDataObject.swift
//  class4 hw
//
//  Created by Steven Shatz on 7/27/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

import Foundation

class SpotifyDataObject {
  
  var urlPathPrefix: String?
  var urlPathSuffix: String?
  
  var albumNameKey: String?
  var imageUrlKey: String?
  
  init() {
    self.urlPathPrefix = "http://ws.spotify.com/1/track.json?q="
    self.urlPathSuffix = "+album"
    self.albumNameKey = "collectionCensoredName"
    self.imageUrlKey = "artworkUrl100"
  }
  
}