//
//  ImageViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 07/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: ViewController {
    private let url:String = "http://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet weak var completedLable: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        //fetchImage()
    }
    
    func fetchImage() {
        
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
//        guard let url = URL(string: "http://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg") else {
//        return
//        }
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//            if let data = data, let image = UIImage(data: data){
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
//                    self.imageView.image = image
//                }
//            }
//        }.resume()
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.image = image
        }
    }
    
    func fetchDataWithAlamofire(){
//        request(url).responseData {responseData in
//            switch responseData.result {
//            case .success(let data):
//                guard let image = UIImage(data: data) else {return}
        AlamofireNetworkRequest.downloadImage(url: url){(image) in
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
        }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    func downloadImageWithProgress(){
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        AlamofireNetworkRequest.completed = { completed in
            self.completedLable.isHidden = false
            self.completedLable.text = completed
        }
        
        
        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageUrl) {
            (image) in
            self.progressView.isHidden = true
            self.completedLable.isHidden = true
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
}
