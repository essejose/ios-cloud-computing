//
//  Rest.swift
//  Cars
//
//  Created by Usuário Convidado on 04/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import Foundation
import UIKit
class REST{
    
    static let basePath = "https://fiapcars.herokuapp.com/cars"
    
    static let configuration: URLSessionConfiguration = {
       let config = URLSessionConfiguration.default
        
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 45.0
            config.httpMaximumConnectionsPerHost = 5
            config.httpAdditionalHeaders = [ "Content-Type" : "application/json" ]
        
        return config
    }()
    
    
    
    static let session = URLSession(configuration: configuration)
    
    static func loadCars( onComplete: @escaping ([Car]?) -> Void){
        
        guard let url = URL(string: basePath) else{return}
        
        session.dataTask(with: url) { (data: Data?, response :URLResponse?, error: Error?) in
            
            if error != nil{
                print("Deu problema")
                onComplete(nil)
                
            }else{
                
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return}
                
                if response.statusCode == 200{
              
                    
                    guard let data = data else {return}
                    
                    do{
                        
                        let json = try JSONSerialization.jsonObject(
                            with: data,
                            options: JSONSerialization
                                .ReadingOptions()) as! [[String: Any]]
                        
                        var cars: [Car] = []
                        
                        for item in json{
                            let brand = item["brand"] as! String
                            let name = item["name"] as! String
                            let price = item["price"] as! Double
                            let gasType = GasType(rawValue:item["gasType"] as! Int)!
                            
                            let id = item["_id"] as! String
                            
                            let car = Car(brand: brand, name: name, price: price, gasType: gasType)
                            car.id = id
                            
                            cars.append(car)
                        }
                        
                        onComplete(cars)
                        
                    }catch{
                    
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                
                
                }else{
                    
                    print("Erro no servidor",response.statusCode)
                    onComplete(nil)
                }
            
            }
            
            
        }.resume()
        
    }
    
    static func saveCar( _ car: Car, onComplete: @escaping (Bool) -> Void){
    
        guard let url = URL(string: basePath) else{
            onComplete(false)
            return
        }
        
        var resquest = URLRequest(url: url)
        resquest.httpMethod = "POST"
        
        let carDict : [String: Any] = [
            "brand" : car.brand,
            "name"  : car.name,
            "price" : car.price,
            "gasType" : car.gasType.rawValue
            
        
        ]
        
        let json =  try! JSONSerialization.data(withJSONObject: carDict,
                                          options: JSONSerialization.WritingOptions())
        
        resquest.httpBody = json
        
        
        session.dataTask(with: resquest){
            (data: Data?, response: URLResponse?, error : Error?) in
            
            if error == nil {
            
                guard let response = response as? HTTPURLResponse else{
                    onComplete(false)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let _ = data else {
                        onComplete(false)

                        return}
                    
                }
                
                onComplete(true)

            } else{
            
                onComplete(false)
                
                
            }
        
            
        }.resume()
        
        
    }
    
    
    static func updateCar( _ car: Car, onComplete: @escaping (Bool) -> Void){
        
        let path = basePath + "/" + car.id!
        
        guard let url = URL(string: path) else{
            onComplete(false)
            return
        }
        
        var resquest = URLRequest(url: url)
        resquest.httpMethod = "PUT"
        
        let carDict : [String: Any] = [
            "brand" : car.brand,
            "name"  : car.name,
            "price" : car.price,
            "gasType" : car.gasType.rawValue,
            "id":car.id!
            
            
        ]
        
        let json =  try! JSONSerialization.data(withJSONObject: carDict,
                                                options: JSONSerialization.WritingOptions())
        
        resquest.httpBody = json
        
        
        session.dataTask(with: resquest){
            (data: Data?, response: URLResponse?, error : Error?) in
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else{
                    onComplete(false)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let _ = data else {
                        onComplete(false)
                        
                        return}
                    
                }
                
                onComplete(true)
                
            } else{
                
                onComplete(false)
                
                
            }
            
            
            }.resume()
        
        
    }
    
    
    static func deleteCar( _ car: Car, onComplete: @escaping (Bool) -> Void){
        
        let path = basePath + "/" + car.id!
        
        guard let url = URL(string: path) else{
            onComplete(false)
            return
        }
        
        var resquest = URLRequest(url: url)
        resquest.httpMethod = "DELETE"
        
        let carDict : [String: Any] = [
            "id":car.id!
            
        ]
        
        let json =  try! JSONSerialization.data(withJSONObject: carDict,
                                                options: JSONSerialization.WritingOptions())
        
        resquest.httpBody = json
        
        
        session.dataTask(with: resquest){
            (data: Data?, response: URLResponse?, error : Error?) in
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else{
                    onComplete(false)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let _ = data else {
                        onComplete(false)
                        
                        return}
                    
                }
                
                onComplete(true)
                
            } else{
                
                onComplete(false)
                
                
            }
            
            
            }.resume()
        
        
    }

    
    
    static func downloadImage(url:String, onComplete: @escaping (UIImage?) -> Void){
    
        guard let url = URL(string: url) else{
            onComplete(nil)
            return
        }
        
        session.downloadTask(with: url) { (imageURL: URL?, response:URLResponse?, error : Error?) in
            if let response = response as? HTTPURLResponse, response.statusCode == 200, let imageURL =
                imageURL{
                
                let imageData = try! Data(contentsOf: imageURL)
                
                let image = UIImage(data: imageData)
                onComplete(image)
                
            }else {
            
                onComplete(nil)
            }
        
        }.resume()
        
        
    
    }
    
}
