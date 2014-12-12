//
//  ViewController.swift
//  class4 hw
//
//  Created by Steven Shatz on 7/26/14.
//  Copyright (c) 2014 Steven Shatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
  
  //items is an array of dictionary objects with string keys and string vals
  //var items = Dictionary<String, String>[]()
  
  var items: NSArray?
  var myAlbum = [Album]()
  var jsonResult: NSDictionary!
  var imageResult: UIImage?
  var sortCounter = 0

  @IBOutlet var albumDisplay: UITableView?

 
  //variables for searching Data Source:
  //------------------------------------
  var searchUrlPathPrefix: String?
  var searchUrlPathSuffix: String?
  var searchNameKey: String?
  var searchImageUrlKey: String?
  
  
  //------- UIView callbacks ---------------
  
  override func viewDidLoad() {
    println("Entering viewDidLoad")
    
    super.viewDidLoad()
    
    //set up for iTunes as Music Data Source - see iTunesDataObject.swift:
    //--------------------------------------------------------------------
    var myItunesObject = ItunesObject()
    
    //var myItunesObject = AmazonDataObject() - not working
    //var myItunesObject = SpotifyDataObject() - not working
    
    searchUrlPathPrefix = myItunesObject.urlPathPrefix!
    searchUrlPathSuffix = myItunesObject.urlPathSuffix!
    searchNameKey = myItunesObject.nameKey!
    searchImageUrlKey = myItunesObject.imageUrlKey!

    
    //Register UITableViewCell class for reuse
  
    //This is for reuse of tableview cells
    self.albumDisplay!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  
    var _obj = SimpleObjC()
    var _bgColor = _obj.getBackgroundColor()
  
    self.view.backgroundColor = _bgColor
    
    println("Exiting viewDidLoad")
  }
  
  //------- END: UIView callbacks ----------
  

  
  //-------- Async network calls --------
  
 
  @IBOutlet var typeOfSearch: UISegmentedControl!
  
  @IBAction func indexChanged(sender: AnyObject) {
    switch (self.typeOfSearch.selectedSegmentIndex) {
    case 0:
      setSearchForMusic()
      break;
    case 1:
      setSearchForEbooks()
      break;
    case 2:
      setSearchForApps()
      break;
    case 3:
      setSearchForPodcast()
      break;
    case 4:
      setSearchForMovies()
      break;
    case 5:
      setSearchForTVShows()
      break;
    default:
      break;
    }
  }
  
  func setSearchForMusic() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=music&entity=album&limit=100"
    searchNameKey = "collectionCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "Artist or Album Name"
  }
  
  func setSearchForEbooks() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=ebook&entity=ebook&limit=100"
    searchNameKey = "trackCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "Book Title or Author"
  }
  
  func setSearchForApps() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=software&entity=iPadSoftware"
    searchNameKey = "trackCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "Name of App or Description"
  }
  
  func setSearchForPodcast() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=podcast&entity=podcast"
    searchNameKey = "trackCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "Podcast Title or Description"
  }
  
  func setSearchForMovies() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=movie&entity=movie&limit=100"
    searchNameKey = "trackCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "Movie Title, Director, or Actor"
  }
  
  func setSearchForTVShows() {
    searchUrlPathPrefix = "https://itunes.apple.com/search?term="
    searchUrlPathSuffix = "&media=tvShow&entity=tvSeason&limit=100"
    searchNameKey = "collectionCensoredName"
    searchImageUrlKey = "artworkUrl100"
    searchTextField!.placeholder = "TV Series Title or Actor"
  }
 
  @IBOutlet var searchTextField: UITextField?
  
  //I believe this makes Keyboard appear when user clicks in text field and disappear when user clicks outside of it
  @IBAction func textEntryDone(sender: AnyObject) {
    self.searchTextField!.becomeFirstResponder()
    self.searchTextField!.resignFirstResponder()
  }
  
  @IBAction func startSearch(sender: AnyObject) {
    asyncNetworkCall()
  }
  
  func asyncNetworkCall() {
    
    //1. Get search term and make it case-insensitive (force to lowercase)
    var _searchTerm:String = (searchTextField!.text as NSString).lowercaseString
    
    // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
    var _adjustedSearchTerm = _searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+",
      options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)

    // Now escape anything else that isn't URL-friendly
    var _escapedSearchTerm = _adjustedSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    println("\n\n\(_escapedSearchTerm)\n\n")
      
    //2. Create URL with HTTP Request
    let urlPath = searchUrlPathPrefix! + _escapedSearchTerm! + searchUrlPathSuffix!
    println("Data Source GET REQUEST \n\n\(urlPath)\n\n")
    
    //3. Create connection object
    let _url: NSURL = NSURL(string: urlPath)!
    let _request: NSURLRequest = NSURLRequest(URL: _url)
    
    println("Before NSURLConnection call")
    
    //4. Make async call and declare 'closure on the fly' to accept the response whenever it is ready
    NSURLConnection.sendAsynchronousRequest(_request, queue: NSOperationQueue.mainQueue()) { //closure starts here
      
      (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
      
      println("In NSURLConnection closure")

        if error != nil {
          println("ERROR: \(error.localizedDescription)")
        } else {
          println("Not Error:")
          var _jsonError: NSError?
          
          //5. Convert JSON to Dictionary
          
          self.jsonResult = NSJSONSerialization.JSONObjectWithData(data,
              options: NSJSONReadingOptions.MutableContainers,
              error: &_jsonError) as NSDictionary
          
          // Now send the JSON result to our delegate object
          
          if _jsonError? != nil {
            println("JSON Error: \(_jsonError?.localizedDescription)")
          } else {
            println("\n\n-------- Response from Data Source --------\n\n")
            println(self.jsonResult)
            
            //now call downloadComplete so we can show some results
            
            self.downloadComplete()
          }
        }
    }  //closure ends here
    
    println("Request sent to Data Source ....")
  }
  
  //-------- End Async network calls --------
  
  
  
  func downloadComplete() {
    
    var _resultsDictionary = self.jsonResult
    var _resultCount = _resultsDictionary["resultCount"] as Int
    var _resultArray = _resultsDictionary["results"] as NSArray
    
    self.items = _resultArray
    
    //Clear artist array
    
    myAlbum.removeAll(keepCapacity: true)
    
    for rowNum in 0..<_resultCount {
      var _dataItemToDisplay:NSDictionary = self.items![rowNum] as NSDictionary
      var _dataItemName = _dataItemToDisplay[searchNameKey!] as String
      
      // Grab the artworkUrl100 key to get an image URL for the app's thumbnail
      var _dataItemImagePath: NSString = _dataItemToDisplay[searchImageUrlKey!] as NSString
      var _dataItemImageUrl: NSURL = NSURL(string: _dataItemImagePath)!
      
      // Request asynchronous download of image
      asynchImageFetch(_dataItemName, imageUrl: _dataItemImageUrl)
      
      //Until real image gets downloaded, hold place with "filler" image
      let _tempDataItemImage: UIImage = UIImage(named: "unknownImage.jpg")!
      
      var _dataItem = Album(name: _dataItemName, image: _tempDataItemImage)
      
      myAlbum.append(_dataItem)
    }

    // self.items = results as Dictionary<String, String>[]
    
    println(self.items)
    
    sortCounter = 0  // Reset so next sort button press will force Ascending order
    
    // self.sortTableViewData(self.albumDisplay!)   // Forcing sort before initial display causes noticeable delay before data appears
    
    self.albumDisplay!.reloadData()
  }
  
  
  
  // Asynchronous fetching of Images
  
  func asynchImageFetch(dataItemName: String, imageUrl: NSURL) {

    let _request: NSURLRequest = NSURLRequest(URL: imageUrl)
  
    NSURLConnection.sendAsynchronousRequest(_request, queue: NSOperationQueue.mainQueue()) {
  
      (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
  
      if error != nil {
        println("ERROR: \(error.localizedDescription)")
      } else {
        self.imageResult = UIImage(data: data)

        for item in self.myAlbum {
          if item.name == dataItemName {
            item.image = self.imageResult
          }
        }
        self.albumDisplay!.reloadData()     
      }
    }
  }

  
  //-------- UITableView delegates ------------
  
  // The following two callback functions are required by the UITableViewDataSource protocol
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
  
  //1. Tell iOS the # rows in the table:
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var _numRows = 0
        if self.items != nil {
            _numRows = self.items!.count
        }
        return _numRows
    }

  //2. Give iOS a cell object for the row it asked for:
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
    // If a cell already exists and is available for reuse, dequeueReusableCellWithIdentifier: will return that cell
    // If a new cell must be created, the dequeueReusableCellWithIdentifier: method initializes the cell by calling its initWithStyle:reuseIdentifier: method
  
    var _cell:UITableViewCell = self.albumDisplay!.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
  
    var _rowNumber = indexPath.row
  
    //myAlbum was created right after download
    var _dataItem = myAlbum[_rowNumber]
    
    _cell.textLabel.text = _dataItem.name
    _cell.imageView.image = _dataItem.image

    return _cell
  }
  
  //-------- END: UITableView delegates ------------
  
  
  
  //-------- START: Sorting --------------------------------
  
  
  @IBAction func sortAlbum(sender: AnyObject) {
    
    var _sortOrder:String?
    
    sortCounter++
    
    if sortCounter % 2 == 0 {
      _sortOrder = "DESC"
    } else {
      _sortOrder = "ASC"
    }
    println("\n\nAbout to do complexSort\n\n")
    
    self.complexSort(_sortOrder!)
  }
  
  
  func complexSort(var _sortOrder:String) {
    
    println("-------- START: Start Object sort ----------------")
    
    var _unsortedArray = self.myAlbum
    
    if _sortOrder == "ASC" {
      self.myAlbum = sorted(_unsortedArray){$0.name < $1.name}
    } else {
      self.myAlbum = sorted(_unsortedArray){$0.name > $1.name}
    }
    
    println("\n\nSort complete...")
    
    self.albumDisplay!.reloadData()
    
    println("-------- END: Start Object sort ----------------")
  }
  
  //-------- END: Sorting ----------------------------------


  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

