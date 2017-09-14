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




class FlickViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    
    
    var movies: [[String:Any]] =  [[String:Any]] ()
    var filteredMovies: [[String:Any]] =  [[String:Any]] ()
    var searchString : String = ""

    let IMG_BASE_URL = "http://image.tmdb.org/t/p/w500"
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkErrorView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // segment control
        let layoutChangeControl = UISegmentedControl(items: [#imageLiteral(resourceName: "rows"), #imageLiteral(resourceName: "grid")])
        layoutChangeControl.sizeToFit()
        layoutChangeControl.tintColor = UIColor(red:0.47, green:0.70, blue:1, alpha: 1)
        layoutChangeControl.selectedSegmentIndex = 0;
        layoutChangeControl.customizeAppearance(for: 35)
        layoutChangeControl.addTarget(self, action: #selector(layoutChangeAction(_:)), for: UIControlEvents.valueChanged)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: layoutChangeControl)
        
        // search bar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        
        
        refreshData(refreshControl: nil, showProgress: true)
        selectLayout(layout : 0) // default to list
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search \(searchText)")
        searchString = searchText;
        
        filterMovie()
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func filterMovie() {
        filteredMovies.removeAll()
        if searchString == "" {
            filteredMovies.append(contentsOf: movies)
            return
        }
        
        // slow force filtering - bleh
        for movie in movies {
            let movieTittle = movie["original_title"] as? String
            if movieTittle!.contains(searchString) {
                filteredMovies.append(movie)
            }
        }
    }

    func selectLayout(layout:Int) {
        if layout == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func layoutChangeAction(_ layoutChangeControl: UISegmentedControl) {
        print("Layout selected \(layoutChangeControl.selectedSegmentIndex)")
        selectLayout(layout: layoutChangeControl.selectedSegmentIndex)
        
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
                self.filterMovie()
                self.tableView.reloadData()
                self.collectionView.reloadData()
                
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
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = filteredMovies[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        
        var posterURL: URL!
        if let posterPath = movie["poster_path"] as? String {
            posterURL = URL(string: IMG_BASE_URL + posterPath)
            cell.poster.setImageWith(posterURL)
        } else {
            cell.poster.image = nil
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath : IndexPath!
        if let cell = sender as? UITableViewCell {
            indexPath = tableView.indexPath(for: cell)
        } else {
            if let cell = sender as? UICollectionViewCell {
                indexPath = collectionView.indexPath(for: cell)
            }
        }
        
        let movie = filteredMovies[indexPath!.row]
        let detailVC = segue.destination as! DetailViewController
        detailVC.movie = movie
        
    }


}
