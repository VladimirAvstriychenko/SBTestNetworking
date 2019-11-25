//
//  MainViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 14/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import UserNotifications
import FBSDKLoginKit
import FirebaseAuth

enum Actions: String, CaseIterable{
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case ourCoursesAlamofire = "Our Courses (Alamofire)"
    case responseData = "ResponseData"
    case responseString = "responseString"
    case response = "response"
    case downloadLargeImage = "Download Large Image"
    case postAlamofire = "POST with Alamofire"
    case putAlamofire = "PUT with Alamofire"
    case uploadImageAlamofire = "Upload Image (Alamofire)"
    
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImage = "https://api.imgur.com/3/image"
private let swiftbookApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

class MainViewController: UICollectionViewController {

    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    
    private var filePath: String?
    
    private func showAlert(){
        alert = UIAlertController(title: "Downloading ...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        
        let size = CGSize(width: 40, height: 40)
                   

        present(alert, animated: true){
           let point = CGPoint(x: self.alert.view.frame.width/2 - size.width/2, y: self.alert.view.frame.height/2 - size.height/2)
           let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
           activityIndicator.color = .gray
           activityIndicator.startAnimating()
           
           let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
           
           
           
           progressView.tintColor = .blue
            //progressView.progress = 0.5
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
                
                if progressView.progress == 1 {
                    self.alert.dismiss(animated: false)
                }
            }
            
           
           self.alert.view.addSubview(activityIndicator)
           self.alert.view.addSubview(progressView)
        }
        
    }
//    let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Images"]
    let actions = Actions.allCases
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        dataProvider.fileLocation = { (location) in
            //Сохранить файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
        
        checkLoggedIn()
        
       
    }
//
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
//        case "Download Image":
//            performSegue(withIdentifier: "showImageView", sender: self)
//        case "GET":
//            NetworkManager.getPressed(url: url)
//        case "POST":
//            NetworkManager.postPressed(url: url)
//        case "Our Courses":
//            performSegue(withIdentifier: "showCoursesSegue", sender: self)
//        case "Upload Images":
//            print("Upload image")
        case .downloadImage:
                performSegue(withIdentifier: "showImageView", sender: self)
        case .get:
                NetworkManager.getPressed(url: url)
        case .post:
                NetworkManager.postPressed(url: url)
        case .ourCourses:
                performSegue(withIdentifier: "showCoursesSegue", sender: self)
        case .uploadImage:
                NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "ResponseData", sender: self)
            AlamofireNetworkRequest.responseData(url: swiftbookApi)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: swiftbookApi)
        case .response:
                   AlamofireNetworkRequest.response(url: swiftbookApi)
        case .downloadLargeImage:
            performSegue(withIdentifier: "LargeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "PostRequest", sender: self)
        case .putAlamofire:
            performSegue(withIdentifier: "PutRequest", sender: self)
        case .uploadImageAlamofire:
            AlamofireNetworkRequest.uploadImage(url: uploadImage)
//        default:
//            break
        }
        
    }
    
    //MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        switch segue.identifier {
        case "showCoursesSegue":
            coursesVC?.fetchData()
        case "OurCoursesAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "showImageView":
            imageVC?.fetchImage()
        case "ResponseData":
            imageVC?.fetchDataWithAlamofire()
        case "LargeImage":
            imageVC?.downloadImageWithProgress()
        case "PostRequest":
                   coursesVC?.postRequest()
        case "PutRequest":
            coursesVC?.putRequest()
        default:
            break
        }
    }
}

extension MainViewController {
    
    private func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path: \(filePath ?? "")"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


//MARK: Facebook SDK

extension MainViewController {
    private func checkLoggedIn(){
        //FACEBOOK TOKEN
//        if !(FBSDKAccessToken.currentAccessTokenIsActive())
        //GOOGLE TOKEN:
        if Auth.auth().currentUser == nil
        {
            print("The user is not logged in")
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginViewController.modalPresentationStyle = .fullScreen
                self.present(loginViewController, animated: true)
                return
            }
        }
    }
}
