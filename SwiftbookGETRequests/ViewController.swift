//
//  ViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 06/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func downloadImagePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showImageSegue", sender: self)
    }
    
    @IBAction func getPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let response = response,
            let data = data else {return}
            print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print (json)
            } catch {
                print(error)
            }
        }.resume()
        
    }
    @IBAction func postPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        let userData = ["Course": "Networking", "Lesson": "GET and POST Requests"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //header
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else {return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response,
            let data = data else {return}
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    @IBAction func ourCoursesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCoursesSegue", sender: self)
    }
}

