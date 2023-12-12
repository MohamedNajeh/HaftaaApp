//
//  NetworkManager.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import Foundation
import Alamofire

enum CError :String , Error{
    case invalidRequest    = "This User Created an Invalid request"
    case unableToComplete  = "Unable to complete your request , please check your connection"
    case invalidResponse   = "Invalid response from the server , please try again "
    case invalidData       = "Invalid response from the server , please try again"
}


class NetworkManager {
    
    static let shared = NetworkManager()
  
    let baseURL   = "https://alhfta.com/api/"
    //let baseURL = "https://hvps.exdezign.com/api/"
    //let baseURL = "https://alhfta.serv2.touch-corp.com/api/"
    
    var delegate:imageUpload?
    
    func fetchData<T:Decodable>(url:String?,decodable:T.Type,completion: @escaping (Result<T,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        print(url)
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(T.self, from: data)
                    // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    func sendData<T:Decodable>(url:String?,params:[String:Any]?,headers:HTTPHeaders?,decodable:T.Type,completion: @escaping (Result<T,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(T.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    
    
    func login(url:String?,phone:String?,password:String?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        var deviceID = ""
        
        if let vendorID = UIDevice.current.identifierForVendor?.uuidString {
            print("Vendor ID: \(vendorID)")
            deviceID = vendorID
        }

        let parameters:[String:Any] = [
            "phone": phone!, //email
            "password": password!, //password
            "device_id": deviceID
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LoginModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func sendFCMToken(url:String?,fcmToken:String?,completion: @escaping (Result<FCMModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "fcm_token": fcmToken!, //email
           ]
        
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(FCMModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }

    
    func register(url:String?,email:String?,phoneNumber:String?,countryID:String?,privacy:String?,section:String?,name:String?,username:String?,password:String?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "email": email!, //email
            "phoneNumber": phoneNumber!, //password
            "country_id": countryID!, //email
            "privacy": privacy!, //password
            "section": section!, //email
            "name": name!, //password
            "username": username!, //email
            "password": password! //password
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let resp = try decoder.decode(LoginModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure(let error):
                print(error)
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func searchAdds(url:String?,categoryID:Int?,cityID:Int?,countryID:Int?,adsType:String?,searchText:String?,completion: @escaping (Result<MyAds,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let parameters:[String:Any] = [
            "category_id": categoryID!,
            "city_id": cityID!,
            "country_id": countryID!,
            "adsType": adsType!,
            "search":searchText!
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(MyAds.self, from: data)
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
    
    func sendCode(url:String?,phone:String?,code:String?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "phone": phone!, //email
            "active_code": code! //password
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LoginModel.self, from: data)
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
    
    func getUser(url:String?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        
        AF.request(url, method: .get,encoding: URLEncoding.queryString,headers: headers ).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LoginModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    //MARK: - upload image
    func RequestUploadImage(  fileDate:Data, completion:  @escaping (Result<FileModel, AFError>, Int?) -> Void){
        let parameters:Parameters = ["file":"file"]
        print("--->",parameters)
         API.shared.performRequest(url: baseURL+"upload_file",
                                  method: .post,
                                  parameters: nil,
                                  headersType: nil,
                                  fileUrlKey: ["file"],
                                  files: [fileDate],
                                  filesNames: ["image.png"],
                                  mimeTypes: ["image/jpg"],
                                  completion: completion)
    }
    
    func RequestUploadImageTransaction(fileDate:Data, parameters:Parameters,completion:  @escaping (Result<FileModel, AFError>, Int?) -> Void){
        //let parameters:Parameters = ["file":"file"]
        print("--->",parameters)
         API.shared.performRequest(url: baseURL+"send_transaction",
                                  method: .post,
                                  parameters: parameters,
                                   headersType: [.authorization(bearerToken: UserInfo.getUserToken())],
                                  fileUrlKey: ["image"],
                                  files: [fileDate],
                                  filesNames: ["image.png"],
                                  mimeTypes: ["image/jpg"],
                                  completion: completion)
    }
    
    
    func RequestUploadVedio(  fileDate:Data, completion:  @escaping (Result<FileModel, AFError>, Int?) -> Void){
        let parameters:Parameters = ["file":"file"]
        print("--->",parameters)
         API.shared.performRequest(url: baseURL+"upload_file",
                                  method: .post,
                                  parameters: nil,
                                  headersType: nil,
                                  fileUrlKey: ["file"],
                                  files: [fileDate],
                                  filesNames: ["video.mp4"],
                                  mimeTypes: ["video/mp4"],
                                  completion: completion)
    }
    
    func uploadVedio(url:String?,fileData:Data?,completion: @escaping (Result<FileModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        RequestUploadVedio(fileDate: fileData!) { [weak self] result, statusCode in
            guard let self = self else { return }
            
            switch result{
            case .success(let model):
                
                if model.status == 200{
                    print("Success Send")
                    self.delegate?.setImgID(id: model.data?.id ?? 0)
                    completion(.success(model))
                    
                    //self.uploadUmage?.imageUpoladed(path: model.data ?? "")
                }else{
                    completion(.failure(.invalidData))
                    //self.error?.featching(error: model.message ?? "")
                }
                break
                
            case .failure(let error):
                print(error)
                print("fail")
                completion(.failure(.invalidData))
            }
        }
        
        
    }
    
    
    func uploadImage(url:String?,fileData:Data?,completion: @escaping (Result<FileModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        RequestUploadImage(fileDate: fileData!) { [weak self] result, statusCode in
            guard let self = self else { return }
            
            switch result{
            case .success(let model):
                
                if model.status == 200{
                    print("Success Send")
                    self.delegate?.setImgID(id: model.data?.id ?? 0)
                    completion(.success(model))
                    
                    //self.uploadUmage?.imageUpoladed(path: model.data ?? "")
                }else{
                    //completion(.failure(model.))
                    //self.error?.featching(error: model.message ?? "")
                }
                break
                
            case .failure(let error):
                print(error)
                print("fail")
            }
        }
    }
    
    func updateProfile(url:String?,name:String?,userName:String?,phoneNumber:String?,country_id:String?,cityID:String?,email:String?,photoPath:String?,password:String?,nationalID:Int?,commericalID:Int?,favor:Int?,workPermit:Int?,segelMadani:String?,allowPhone:Int?,allowWhats:Int?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        let parameters:[String:Any] = [
            "namw": name!, //email
            "userName": userName!, //password
            "phoneNumber": phoneNumber!, //email
            "country_id": country_id!, //password
            "city_id": cityID!, //email
            "email": email!, //password
            "photo_path": photoPath!, //email
            "password": password!, //password
            "national_identity": nationalID!,
            "commercial_register": commericalID!,
            "favour": favor!,
            "work_permit": workPermit!,
            "sajal_madaniun": segelMadani!,
            "allow_phone": allowPhone!,
            "whatsapp": allowWhats!
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let resp = try decoder.decode(LoginModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidRequest))
            }
            
        }
        
    }
    
    func logOut(url:String?,completion: @escaping (Result<LogOut,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        
        AF.request(url, method: .get,encoding: URLEncoding.queryString,headers: headers ).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LogOut.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
    }
    
    func addNewAdd(url:String?,adsType:String?,title:String?,detail:String?,country_id:Int?,city_id:Int?,area_id:Int?,phoneAllow:Int?,video:Int?,commentAllow:Int?,photos:[Int],category_id:Int?,lat:String?,lng:String?,accpet:Int?,accept_title:String?,completion: @escaping (Result<MyAds,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        
        let parameters:[String:Any] = [
            "adsType": adsType!, //email
            "title": title!, //password
            "detail": detail!, //email
            "country_id": country_id!, //password
            "city_id": city_id!, //email
            "phoneAllow": phoneAllow!, //password
            "video": video!, //email
            "commentAllow": commentAllow!,
            "photos": photos, //password
            "category_id": category_id!, //email
            "lat": lat!, //password
            "lng": lng!, //password
            "accept": accpet!, //email
            "accept_title": accept_title!, //password
            "area_id":area_id!
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let resp = try decoder.decode(MyAds.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func updateAdd(url:String?,adsType:String?,title:String?,detail:String?,country_id:Int?,city_id:Int?,area_id:Int?,phoneAllow:Int?,video:Int?,commentAllow:Int?,photos:[Int],category_id:Int?,lat:String?,lng:String?,accpet:Int?,accept_title:String?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        
        let parameters:[String:Any] = [
            "adsType": adsType!, //email
            "title": title!, //password
            "detail": detail!, //email
            "country_id": country_id!, //password
            "city_id": city_id!, //email
            "phoneAllow": phoneAllow!, //password
            "video": video!, //email
            "commentAllow": commentAllow!,
            "photos": photos, //password
            "category_id": category_id!, //email
            "lat": lat!, //password
            "lng": lng!, //password
            "accept": accpet!, //email
            "accept_title": accept_title!, //password
            "area_id":area_id!
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    
    func addFavorite(url:String?,addID:Int?,completion: @escaping (Result<AddFavoriteModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "ads_id": addID!, //email
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddFavoriteModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func addRate(url:String?,addID:Int?,rate:Int?,description:String?,completion: @escaping (Result<MyAds,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        let parameters:[String:Any] = [
            "ads_id": addID!,
            "rate": rate!,
            "description": description!
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(MyAds.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func reportAd(url:String?,addID:Int?,reasonID:Int?,comment:String?,completion: @escaping (Result<MyAds,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        let parameters:[String:Any] = [
            "ads_id": addID!,
            "reason_id": reasonID!,
            "comment": comment!
           ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(MyAds.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func sendMessage(url:String?,id:Int?,message:String?,completion: @escaping (Result<LoginModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "user_id": id!, //email
            "message": message! //password
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(LoginModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func addCommentToGeneral(url:String?,chat_id:Int?,message:String?,parentID:Int?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "chat_id": chat_id!, //email
            "message": message!, //password
            "parent_id": parentID!, //password
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func deleteComment(url:String?,comment_id:Int?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "comment_id": comment_id!
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func addCommentToAdd(url:String?,chat_id:Int?,comment:String?,parent_id:Int?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "ads_id": chat_id!, //email
            "comment": comment!, //password
            "parent_id": parent_id!,
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    
    func contactUS(url:String?,name:String?,phone:String?,email:String?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "name": name!, //email
            "phone": phone!, //password
            "email": email!,
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func forgetPass(url:String?,phone:String?,completion: @escaping (Result<ForgetPssModel,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "phone": phone!, //email
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(ForgetPssModel.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func newPass(url:String?,password:String?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
        
        let parameters:[String:Any] = [
            "password": password!, //email
           ]
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
    
    func archiveAdd(url:String?,completion: @escaping (Result<AddGeneralComment,CError>) -> Void){
        guard let url = URL(string:"\(baseURL+url!)") else {return}
    
        let headers: HTTPHeaders = [.authorization(bearerToken: UserInfo.getUserToken())]
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default,headers:headers).response { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(AddGeneralComment.self, from: data)
                   // guard let cont = resp.data else{return}
                    completion(.success(resp))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.invalidData))
            }
            
        }
        
    }
}
    
