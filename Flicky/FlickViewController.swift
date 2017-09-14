//
//  FlickViewController.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/10/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class FlickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [[String:Any]] =  [[String:Any]] ()
    let IMG_BASE_URL = "http://image.tmdb.org/t/p/w500"
    var endpoint: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkErrorView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshData(refreshControl: nil, showProgress: true)
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshData(refreshControl: refreshControl, showProgress: false)
    }
    
    func refreshData(refreshControl: UIRefreshControl?, showProgress : Bool) {
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 5
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        if showProgress {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        self.networkErrorView.isHidden = true

        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
        { (dataOrNil, response, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                self.networkErrorView.isHidden = false
                print("Error loading \(self.endpoint!)")
                refreshControl?.endRefreshing()
                return
            } else {
                self.networkErrorView.isHidden = true
            }
            
            if let data = dataOrNil {
                let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dictionary["results"] as! [[String:Any]]
                self.tableView.reloadData()
                print("Finished loading \(self.endpoint!)")
            }
            refreshControl?.endRefreshing()
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.movieTitle.text = movie["original_title"] as? String
        cell.movieDes.text = movie["overview"] as? String
        
        var posterURL: URL!
        if let posterPath = movie["poster_path"] as? String {
            posterURL = URL(string: IMG_BASE_URL + posterPath)
            cell.poster.setImageWith(posterURL)
        } else {
            cell.poster.image = nil
        }
        

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        let detailVC = segue.destination as! DetailViewController
        detailVC.movie = movie
        
    }


}
