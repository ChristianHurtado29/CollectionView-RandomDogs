//
//  Dog.swift
//  CollectionView-RandomDogs
//
//  Created by Christian Hurtado on 1/14/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation

typealias DogImage = String
    
struct Dog: Decodable{
    let message: [DogImage]
}
