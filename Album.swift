//
//  Album.swift
//  class4 hw
//
//  Created by Steven Shatz on 7/27/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

import Foundation

class Album {
  var name: String?
  var image: UIImage?
  
  init(name: String, image: UIImage) {
    self.name = name
    self.image = image
  }
  
  func getName() -> String {
    return name!
  }
  
  func getImage() -> UIImage {
    return image!
  }
  
}