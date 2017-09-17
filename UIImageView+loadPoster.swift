//
//  UIImageView+loadPoster.swift
//  Flicky
//
//  Created by Phuong Nguyen on 9/17/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking

extension UIImageView {
    func loadPosterImage(movie:[String:Any]) {
        let IMG_BASE_URL = "http://image.tmdb.org/t/p"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = URL(string: IMG_BASE_URL + "/w154" + posterPath)!
            //            cell.poster.setImageWith(posterURL)
            let imageRequest = URLRequest(url: posterURL)
            
            
            setImageWith(imageRequest,
                         placeholderImage: nil,
                         success: {(request, response, poster) -> Void in
                            if response != nil {
                                print("Image was NOT cached, fade in image")
                                self.alpha = 0.0
                                self.image = poster
                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                    self.alpha = 1.0
                                })
                            } else {
                                print("Image was cached so just update the image")
                                self.image = poster
                            }
                            
            }, failure: {(request, response, image) -> Void in
            })
        } else {
            image = nil
        }
    }
    
    func loadPosterImageDual(movie:[String:Any]) {
        let IMG_BASE_URL = "http://image.tmdb.org/t/p"
        
        let posterPath:String? = movie["poster_path"] as? String
        if (posterPath == nil) {
            image = nil
            return
        }
        
        let smallPosterURL = URL(string: IMG_BASE_URL + "/w154" + posterPath!)!
        let largePosterURL = URL(string: IMG_BASE_URL + "/w780" + posterPath!)!
        
        
        let smallImageRequest = URLRequest(url: smallPosterURL)
        let largeImageRequest = URLRequest(url: largePosterURL)
        
        setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                var animationDuration:Double!
                if smallImageResponse != nil {
                    print("Small was NOT cached, fade in image")
                    self.alpha = 0.0
                    animationDuration = 0.4
                    self.image = smallImage

                } else {
                    self.alpha = 1.0
                    animationDuration = 0.1
                    print("Small image was cached so just update the image")
                }
                
                
                UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                    self.alpha = 1.0
                }, completion: { (sucess) -> Void in
                    self.setImageWith(
                    largeImageRequest,
                    placeholderImage: smallImage,
                    success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                    print("Loaded large image")
                    self.image = largeImage;
                    },
                    failure: { (request, response, error) -> Void in
                    print("Could not load large image")
                    
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                print("Could not load small image")
        })
    }
}
    
