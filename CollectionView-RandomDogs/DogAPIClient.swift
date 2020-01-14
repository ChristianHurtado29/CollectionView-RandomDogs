//
//  DogAPIClient.swift
//  CollectionView-RandomDogs
//
//  Created by Christian Hurtado on 1/14/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation
import NetworkHelper
struct DogAPIClient {
    static func fetchDogs(completion: @escaping (Result <[DogImage], AppError>) -> () ){
        let endpointURL = "https://dog.ceo/api/breeds/image/random/50"
        
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let dogs = try JSONDecoder().decode(Dog.self, from: data)
                    completion(.success(dogs.message))
                }catch{
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
