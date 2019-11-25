//
//  CoursesViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 07/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit

class CoursesViewController: ViewController {
    private var courseName: String?
    private var courseURL: String?
    private var courses = [Course]()
    private var url = "http://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    @IBOutlet weak var tableView: UITableView!
    
    
    func fetchData() {
        //let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_course"
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_courses"
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_website_description"
//        let jsonUrlString = "http://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
//        guard let url = URL(string: jsonUrlString) else {return}
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data,
//                let response = response else {return}
//
//            do {
////                let course = try JSONDecoder().decode(Course.self, from: data)
////                print(course.name)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                self.courses = try decoder.decode([Course].self, from: data)
//                print(self.courses)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
////                let websiteDescription = try JSONDecoder().decode(WebSiteDescription.self, from: data)
////                print("\(websiteDescription.websiteName ?? "") \(websiteDescription.websiteDescription ?? "")")
//            }
//            catch {
//                print("Erros serialization JSON", error)
//            }
//        }.resume()
        NetworkManager.fetchData(url: url) {(courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath){
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        if let numberOfLessons = course.numberOfLessons{
            cell.numberOfLessonsLabel.text = "Number of lessons: \(numberOfLessons)"
        }
        if let numberOfTests = course.numberOfTests{
            cell.numberOfTestsLabel.text = "Number of lessons: \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else {return}
            guard let imageData = try? Data(contentsOf: imageUrl) else {return}
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! DescriptionViewController
        webViewController.selectedCourse = courseName
        if let url = courseURL{
            webViewController.courseURL = url
        }
    }
    
    func fetchDataWithAlamofire(){
        AlamofireNetworkRequest.sendRequest(url: url) { (courses) in
        self.courses = courses
        DispatchQueue.main.async {
            self.tableView.reloadData()
            }
            
        }
    }
    
    func postRequest(){
        AlamofireNetworkRequest.postRequest(url: postRequestUrl){ (courses) in
            self.courses = courses
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    func putRequest(){
        AlamofireNetworkRequest.putRequest(url: putRequestUrl){ (courses) in
            self.courses = courses
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
}



extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int{
        return courses.count
    }
    
    
    
}

extension CoursesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
         
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let course = courses[indexPath.row]
//        print(indexPath.row)
//        courseURL = course.link
//        courseName = course.name
//        performSegue(withIdentifier: "showDescriptionSegue", sender: self)
        
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "showDescriptionSegue", sender: self)
    }
    
}
