//
//  API.swift
//  Haftaa
//
//  Created by Najeh on 23/07/2022.

import Foundation
import Alamofire

@available(iOS 13.0, *)
class API{
    static var shared = API()
    
    func getData<T: Decodable>(url: String, method: HTTPMethod ,params: Parameters?, encoding: ParameterEncoding ,headers: HTTPHeaders? ,completion: @escaping (T?,Int, Error?)->()) {
        
        AF.request(url, method: method, parameters: params , encoding: encoding, headers: headers)
            .validate(statusCode: 200...300)
            .responseJSON { (response) in
                print("parameters",params)
                print("Status code ->",response.response?.statusCode ?? 0)
                switch response.result {
                case .success(_):
                    print("Responce ",response.value)
                    guard let data = response.data else { return }
                    do {
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completion(jsonData,response.response?.statusCode ?? 0, nil)
                        
                    } catch let jsonError {
                        print(jsonError.localizedDescription)
                    }
                    
                case .failure(let error):
                    // switch on Error Status Code
                    print(error.localizedDescription)
                    guard let data = response.data else { return }
                    guard let statusCode = response.response?.statusCode else { return }
                    print("Status code ->",response.response?.statusCode ?? 0)
                    switch statusCode {
                    case 400..<500:
                        do {
                            let jsonError = try JSONDecoder().decode(T.self, from: data)
                            completion(jsonError,response.response?.statusCode ?? 0, nil)
                            
                        } catch let jsonError {
                            print(jsonError)
                        }
                    default:
                        completion(nil,response.response?.statusCode ?? 0, error)
                    }
                }
        }
    }
    

    //MARK: - peform request without body

    @discardableResult
    func performRequest<T:Decodable>(url: String, method: HTTPMethod, headersType: HTTPHeaders, completion:@escaping (_ result: Result<T, AFError>,_ statusCode:Int?)->Void) -> DataRequest {
         
        return AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable (decoder: JSONDecoder()){ (response: DataResponse<T, AFError>) in
            debugPrint(response)
            completion(response.result, response.response?.statusCode)
        }
    }
    
    //MARK: - peform request with body
    @discardableResult
    func performRequest<T:Decodable, M:Encodable>(url: String, method: HTTPMethod, RequestModel: M?, headersType: HTTPHeaders, completion:@escaping (_ result: Result<T, AFError>,_ statusCode:Int?)->Void) -> DataRequest {
            
        return AF.request(url, method: method, parameters: RequestModel, encoder: JSONParameterEncoder.default, headers: nil).responseDecodable (decoder: JSONDecoder()){ (response: DataResponse<T, AFError>) in
            debugPrint(response)
            completion(response.result, response.response?.statusCode)
        }
        
    }
    
    //MARK: - perform MultiPart Request
    @discardableResult
    func performRequest<T:Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, headersType: HTTPHeaders?, fileUrlKey: [String], files:[Data], filesNames:[String], mimeTypes:[String], completion: @escaping (_ result:Result<T, AFError>,_ statusCode:Int?)->Void) -> DataRequest {
        
        return AF.upload(multipartFormData: { (multipartFormData) in

            for index in 0..<fileUrlKey.count{
                multipartFormData.append(files[index], withName: fileUrlKey[index], fileName: filesNames[index], mimeType: mimeTypes[index])
            }

            
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
 
            
        }, to: url, headers:nil).responseDecodable (decoder: JSONDecoder()){ (response: DataResponse<T, AFError>) in

            debugPrint(response)
            completion(response.result, response.response?.statusCode)
        }
    }
    
 
}


