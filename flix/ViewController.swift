//
//  ViewController.swift
//  flix
//
//  Created by Michael Wornow on 6/21/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var photoMainTableView: UITableView!
    
    // Info on returned movies
    var movies: [[String: Any]] = []
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
        
        // Set up The Movie DB config information
        let url = URL(string: generateURL(apiURL: configURL))!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
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
                        print(error.localizedDescription)
                    } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.movies = dataDictionary["results"] as! [[String: Any]]
                        self.totalMovies = dataDictionary["total_results"] as! Int
                    }
                    self.photoMainTableView.reloadData()
                }
                task.resume()
            }
            self.photoMainTableView.reloadData()
        }
        task.resume()
        
        //Set up table view
        photoMainTableView.delegate = self
        photoMainTableView.dataSource = self
    }
    
    func generateURL(apiURL: String, page: Int? = nil) -> String {
        var url = apiURL + "?api_key=" + API_KEY
        if page != nil {
            url += "&page=" + String(page!)
        }
        return url
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = photoMainTableView.dequeueReusableCell(withIdentifier: "photoMain") as! photoMainTableViewCell
        let movie = movies[indexPath.row]
        
        let title = movie["title"] as! String
        let description = movie["overview"] as! String
        let imageURL = movie["poster_path"] as! String
        
        cell.movieTitleLabel.text = title
        cell.descriptionLabel.text = description
        if baseImageURL != "" {
            let fullImageURL = URL(string: baseImageURL + "w500" + imageURL)!
            cell.photoImageView.af_setImage(withURL: fullImageURL)
        }
        
        return cell
    }
    

}

