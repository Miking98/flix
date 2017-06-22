//
//  collectionViewController.swift
//  flix
//
//  Created by Michael Wornow on 6/21/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import AlamofireImage

class collectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Info on returned movies
    var movies: [[String: Any]] = []
    var totalMovies = 0
    // The Movie Database URL's
    let API_KEY = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let configURL = "https://api.themoviedb.org/3/configuration"
    var baseImageURL = ""
    let actionURL = "https://api.themoviedb.org/3/genre/28/movies"
    
    @IBOutlet weak var spinnerActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var superheroCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerActivityIndicatorView.startAnimating()
        
        //Set up collection view
        superheroCollectionView.dataSource = self
        superheroCollectionView.delegate = self
        
        // Set up The Movie DB config information
        let url = URL(string: generateURL(apiURL: configURL))!
        print(url)
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
                let url = URL(string: self.generateURL(apiURL: self.actionURL, page: 1))!
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
                let task = session.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        self.alertNetworkError()
                        print(error.localizedDescription)
                    } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.movies = dataDictionary["results"] as! [[String: Any]]
                        self.totalMovies = dataDictionary["total_results"] as! Int
                    }
                    self.superheroCollectionView.reloadData()
                    self.spinnerActivityIndicatorView.stopAnimating()
                }
                task.resume()
            }
        }
        task.resume()
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
    
    func generateURL(apiURL: String, page: Int? = nil) -> String {
        var url = apiURL + "?api_key=" + API_KEY
        if page != nil {
            url += "&page=" + String(page!)
        }
        return url
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperheroCell", for: indexPath) as! SuperheroCell
        let movie = movies[indexPath.row]
        
        let imageURL = movie["poster_path"] as! String
        let fullImageURL = baseImageURL + "w500" + imageURL
        cell.superheroImageView.af_setImage(withURL: URL(string: fullImageURL)!)
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
