//
//  NetworkManager.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 14/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func getPressed(url: String ) {
        guard let url = URL(string: url) else {return}
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
    
    static func postPressed(url: String) {
        guard let url = URL(string: url) else {return}
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
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()){
        guard let url = URL(string: url) else {
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    completion(image )
                }
            }
        }.resume()
    }
    
    static func fetchData(url: String, completion: @escaping (_ courses: [Course]) -> ()) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            
            do {
                //                let course = try JSONDecoder().decode(Course.self, from: data)
                //                print(course.name)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
               
                //                let websiteDescription = try JSONDecoder().decode(WebSiteDescription.self, from: data)
                //                print("\(websiteDescription.websiteName ?? "") \(websiteDescription.websiteDescription ?? "")")
            }
            catch {
                print("Erros serialization JSON", error)
            }
        }.resume()
    }
    
    static func uploadImage(url: String) {
        let image = UIImage(named: "lotus-978659_1280")!
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else {return}
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        let httpHeaders = ["Authorization": "Client-ID dda76eec0510f34"]
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data{
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
}
