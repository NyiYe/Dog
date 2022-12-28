//
//  DogViewModel.swift
//  Dog
//
//  Created by Nyi Ye Han on 25/11/2022.
//

import Foundation
import UIKit

class DogViewModel : ObservableObject{
    
    @Published var image : UIImage?
    @Published var planet : Planet?
    // add new feature
    func getDogs(){
        //https://dog.ceo/api/breeds/image/random
        
        //        var component = URLComponents(string: "https://dog.ceo/api/breeds/image/random")
        var component = URLComponents()
        component.scheme = "https"
        component.host = "www.dog.ceo"
        component.path = "api/breeds/image/random"
        print(component.debugDescription)
        ////
        //        guard let url = component.url else{
        //            print("unkown url")
        //            return
        //        }
        
        let request = URLRequest(url: URL(string: "https://dog.ceo/api/breeds/image/random")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                print("No data.")
                return
            }
            guard  error == nil else{
                print("\(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                print("Invalid response!")
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else{
                print("Response status code should be 2xx but is \(response.statusCode)")
                return
            }
            do{
//
//                let dog =   try JSONDecoder().decode(Dog.self, from: data)
//                print(dog.message)
                
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                let url = json["message"] as! String
                print("url ::: \(url)")
                URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, error in
                    
                    guard let data = data else{
                        print("No data.")
                        return
                    }
                    guard  error == nil else{
                        print("\(String(describing: error))")
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else{
                        print("Invalid response!")
                        return
                    }
                    guard response.statusCode >= 200 && response.statusCode < 300 else{
                        print("Response status code should be 2xx but is \(response.statusCode)")
                        return
                    }
                    
                    print("success")
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                    
                }.resume()
                
                
            }catch{
                print(error.localizedDescription)
            }
            
//            let jsonString = String(data: data, encoding: .utf8)
//            print(jsonString ?? "empty json string")
        }.resume()
    }
    
    func convertJsonToData() -> Data{
        return    """
        {
            "name" : "Earth",
            "type": "rocky",
            "standardGravity": 9.81,
            "hoursInDay": 24
        }
        """.data(using: .utf8)!
    }
    
    func decodeJsonToStruct(){
        
            do {
                let data = convertJsonToData()
               let earth =  try JSONDecoder().decode(Planet.self, from: data)
                print(earth)
            } catch  {
                print(error)
            }
        
       
    }
    
}

struct Dog : Decodable{
    var status : String
    var message: String
}

struct Planet: Codable {
    let name: String
    let type: String
    let standardGravity: Double
    let hoursInDay: Int
}


struct AppConstants {
    static var scheme = "https"
    static var host = "dog.ceo"
    static var path = "api/breeds/image/random"
}


enum ApiError : Int{
    

    case FourZeroOne = 401
    case FourZeroFour = 404
    
    var message : String{
        switch self {
        case .Four03:
            return "not Found"
        case .two:
            return "One"
        }
    }
    

    
  
   
}







