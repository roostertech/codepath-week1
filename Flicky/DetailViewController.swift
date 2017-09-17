//
//  DetailViewController.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/13/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    let IMG_BASE_URL = "http://image.tmdb.org/t/p/w500"

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie : [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        // Do any additional setup after loading the view.
        print(movie)
        poster.loadPosterImageDual(movie: movie)

        movieOverview.text = movie["overview"] as? String
        movieTitle.text = movie["original_title"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
