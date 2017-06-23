//
//  ViewController.swift
//  flix
//
//  Created by Michael Wornow on 6/21/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var spinnerActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var photoMainTableView: UITableView!
    @IBOutlet weak var photoMainSearchBar: UISearchBar!
    
    // Info on returned movies
    var movies: [[String: Any]] = []
    var filteredMovies: [[String: Any]] = []
    var totalMovies = 0
    // The Movie Database URL's
    let API_KEY = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let configURL = "https://api.themoviedb.org/3/configuration"
    var baseImageURL = ""
    let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerActivityIndicatorView.startAnimating()
        
        // Set up search bar
        photoMainSearchBar.delegate = self
        
        // Set up table view
        photoMainTableView.delegate = self
        photoMainTableView.dataSource = self
        
        // Set up The Movie DB config information
        let url = URL(string: generateURL(apiURL: configURL))!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.alertNetworkError()
                print(error.localizedDescription)
            } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let images = dataDictionary["images"] as! [String: Any]
                self.baseImageURL = images["secure_base_url"] as! String
                
                // Fetch data from The Movie DB
                let url = URL(string: self.generateURL(apiURL: self.nowPlayingURL, page: 1))!
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        self.alertNetworkError()
                        print(error.localizedDescription)
                    } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.movies = dataDictionary["results"] as! [[String: Any]]
                        self.filteredMovies = self.movies
                        self.totalMovies = dataDictionary["total_results"] as! Int
                    }
                    self.photoMainTableView.reloadData()
                    self.spinnerActivityIndicatorView.stopAnimating()
                }
                task.resume()
            }
        }
        task.resume()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        photoMainTableView.insertSubview(refreshControl, at: 0)
    }
    
    func alertNetworkError() {
        let alertController = UIAlertController(title: "Network Error", message: "Error fetching data from The Movie Database. Please check your network connection.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Reload page
            self.viewDidLoad()
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true){}
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let url = URL(string: generateURL(apiURL: nowPlayingURL, page: 1))!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                self.movies = dataDictionary["results"] as! [[String: Any]]
                self.totalMovies = dataDictionary["total_results"] as! Int
            }
            self.photoMainTableView.reloadData()
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = photoMainTableView.indexPath(for: cell) {
            let movie = filteredMovies[indexPath.row]
            let dvc = segue.destination as! detailViewController
            dvc.movie = movie
            dvc.baseImageURL = baseImageURL
        }
    }
    
    func generateURL(apiURL: String, page: Int? = nil) -> String {
        var url = apiURL + "?api_key=" + API_KEY
        if page != nil {
            url += "&page=" + String(page!)
        }
        return url
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoMainTableView.dequeueReusableCell(withIdentifier: "photoMain") as! photoMainTableViewCell
        let movie = filteredMovies[indexPath.row]
        
        let title = movie["title"] as! String
        let description = movie["overview"] as! String
        let imageURL = movie["poster_path"] as! String
        
        cell.movieTitleLabel.text = title
        cell.descriptionLabel.text = description
        if baseImageURL != "" {
            let fullImageURL = URL(string: baseImageURL + "w500" + imageURL)!
            let fullImageRequest = URLRequest(url: fullImageURL)
            cell.photoImageView.af_setImage(withURLRequest: fullImageRequest, placeholderImage: #imageLiteral(resourceName: "movie_poster_placeholder"), imageTransition: .crossDissolve(0.8), runImageTransitionIfCached: false)
        }
        
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: [String: Any]) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        photoMainTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.searchBar(searchBar, textDidChange: "")
    }

}

