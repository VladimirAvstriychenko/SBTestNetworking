//
//  WebSiteDescription.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 09/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import Foundation

struct WebSiteDescription: Decodable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
