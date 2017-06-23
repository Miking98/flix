//
//  detailViewController.swift
//  flix
//
//  Created by Michael Wornow on 6/21/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit
import AlamofireImage

enum MovieKeys {
    static let title = "title"
    static let date = "release_date"
    static let description = "overview"
    static let rating = "vote_average"
    static let backdropPath = "backdrop_path"
    static let posterPath = "poster_path"
}

class detailViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var movie: [String: Any]?
    var baseImageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            titleLabel.text = movie[MovieKeys.title] as? String
            dateLabel.text = movie[MovieKeys.date] as? String
            descriptionTextView.text = movie[MovieKeys.description] as? String
            ratingLabel.text = String(format: "%.1f", movie[MovieKeys.rating] as! Double)
            let backdropFullPath = baseImageURL + "w500" + (movie[MovieKeys.backdropPath] as! String)
            let posterFullPath = baseImageURL  + "w500" + (movie[MovieKeys.posterPath] as! String)
            let backdropURL = URL(string: ViewController().generateURL(apiURL: backdropFullPath))!
            let posterURL = URL(string: ViewController().generateURL(apiURL: posterFullPath))!
            
            let backdropImageRequest = URLRequest(url: backdropURL)
            let posterImageRequest = URLRequest(url: posterURL)
            
            splashImageView.af_setImage(withURLRequest: backdropImageRequest, imageTransition: .crossDissolve(0.8), runImageTransitionIfCached: false)
            thumbnailImageView.af_setImage(withURLRequest: posterImageRequest, runImageTransitionIfCached: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! trailerViewController
        
        vc.movie = movie
    }
    

}
