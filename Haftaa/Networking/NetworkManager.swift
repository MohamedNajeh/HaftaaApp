//
//  NetworkManager.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import Foundation
import Alamofire
enum SPError :String , Error{
    case invalidRequest    = "This User Created an Invalid request"
    case unableToComplete  = "Unable to complete your request , please check your connection"
    case invalidResponse   = "Invalid response from the server , please try again "
    case invalidData       = "Invalid response from the server , please try again"
}

class NetworkManager {
    
    static let shared = NetworkManager()
   // let baseURL = "http://hafttest.haftastore.com/"
    func fetchCountries(url:String?,completion: @escaping (Result<countriesRoot,SPError>) -> Void){
        guard let url = URL(string:url!) else {return}
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(countriesRoot.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    func fetchTypes(url:String?,completion: @escaping (Result<typeRoot,SPError>) -> Void){
        guard let url = URL(string:url!) else {return}
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(typeRoot.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    func fetchPrivacyPolicy(url:String?,completion: @escaping (Result<Policy,SPError>) -> Void){
        guard let url = URL(string:url!) else {return}
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(Policy.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
}
