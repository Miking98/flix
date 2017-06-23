//
//  trailerViewController.swift
//  flix
//
//  Created by Michael Wornow on 6/22/17.
//  Copyright © 2017 Michael Wornow. All rights reserved.
//

import UIKit

class trailerViewController: UIViewController {
        
    @IBOutlet weak var trailerWebView: UIWebView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var spinnerActivityIndicatorView: UIActivityIndicatorView!
    
    var movie: [String: Any]?
    var baseYoutubeURL = "https://www.youtube.com/watch?v="
    var baseVideoInfoURL = "https://api.themoviedb.org/3/movie/{movie_id}/videos"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            self.infoLabel.text = "Trailer for "+(movie["title"] as! String)
            self.spinnerActivityIndicatorView.startAnimating()
            let videoURL = baseVideoInfoURL.replacingOccurrences(of: "{movie_id}", with: String(format: "%d", movie["id"] as! Int))
            let url = URL(string: ViewController().generateURL(apiURL: videoURL, page: 1))!
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.alertNetworkError()
                    print(error.localizedDescription)
                } else if let data = data, let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let trailers = dataDictionary["results"] as! [[String: Any]]
                    
                    if trailers.count == 0 {
                        self.infoLabel.text = "No trailers available"
                    }
                    else {
                        // Load Youtube video
                        let trailerYoutubeID = trailers[0]["key"] as! String
                        let trailerURL = URL(string: self.baseYoutubeURL + trailerYoutubeID)!
                        let request = URLRequest(url: trailerURL)
                        self.trailerWebView.loadRequest(request)
                    }
                }
                self.spinnerActivityIndicatorView.stopAnimating()
            }
            task.resume()
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissModel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
