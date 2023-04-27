//
//  ImageManager.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 27.04.2023.
//

import Foundation

import Alamofire

class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    func getUserImage(from url: String, completion: @escaping (Data) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let imageData):
                    completion(imageData)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
