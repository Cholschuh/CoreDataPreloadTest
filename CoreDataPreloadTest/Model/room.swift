//
//  Room.swift
//  CoreDataPreloadTest
//
//  Created by Chris Holschuh on 1/29/20.
//  Copyright © 2020 Chris Holschuh. All rights reserved.
//

import Foundation

struct room: Codable{
    
    var name: String
    var floor: String
    var information: String
    var photo: String
    var beaconMinorVal: String?
    var beaconMajorVal: String?
    var isVisited: Bool
    
}
