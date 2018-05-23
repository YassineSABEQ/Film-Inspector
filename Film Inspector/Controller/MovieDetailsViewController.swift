//
//  MovieDetailsViewController.swift
//  Film Inspector
//
//  Created by Yassine Sabeq on 5/23/18.
//  Copyright © 2018 Yassine Sabeq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class MovieDetailsViewController: UIViewController {
    
    let OMDb_URL : String = "http://www.omdbapi.com/?apikey=9b507457"
    
    var selectedMovie : Movie?
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    @IBOutlet weak var movieStars: UILabel!
    @IBOutlet weak var movieWriters: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieTitle.text = selectedMovie?.name
        
        let param : [String : String] = ["t" : (selectedMovie?.name)!]
        
        getMovieData (url : OMDb_URL , parameters : param)

    }

   
    
    func getMovieData (url : String , parameters : [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                
                let movieJSON : JSON = JSON(response.result.value!)
                self.updateMovieDetailsUI(json: movieJSON)
                
            } else {
                print("error \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateMovieDetailsUI (json : JSON) {
        
        if json["Title"].string != nil {
            
            self.releaseDate.text = json["Released"].stringValue
            self.movieRuntime.text = json["Runtime"].stringValue
            self.moviePlot.text = json["Plot"].stringValue
            self.moviePlot .sizeToFit()
            self.movieDirector.text = json["Director"].stringValue
            self.movieGenre.text = json["Genre"].stringValue
            self.movieGenre .sizeToFit()
            self.movieStars.text = json["Actors"].stringValue
            self.movieStars .sizeToFit()
            self.movieWriters.text = json["Writer"].stringValue
            self.movieWriters .sizeToFit()
            self.moviePoster.sd_setImage(with: URL(string: json["Poster"].stringValue), placeholderImage: UIImage(named: "placeholder.png"))
        }
    }
    
}
