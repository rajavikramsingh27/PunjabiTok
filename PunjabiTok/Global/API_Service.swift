

//  API_FUNC.swift
//  PunjabiTok
//  Created by GranzaX on 11/06/21.




import Foundation
import Alamofire
import SwiftMessageBar
import SwiftyJSON




class API_Service {
    class func api(
        _ url: String ,
        _ parameters: [String:Any],
        _ httpHeaders:HTTPHeaders,
        _ method:HTTPMethod,
        completion: @escaping ( _ json:JSON) -> ()) {
        if Reachability.isConnectedToNetwork() {
            debugPrint(kBaseURL+url)
            debugPrint(method)
            debugPrint(parameters)
            debugPrint(httpHeaders)
            
            //            let manager = AF.session
            //            manager.configuration.timeoutIntervalForRequest = 80
            
            Alamofire.request(
                kBaseURL+url,
                method: method,
                parameters: parameters,
                headers: httpHeaders).validate().responseString { (response) in
                    debugPrint(response)
                    debugPrint(response.description)
                    
                    switch response.result {
                    case .success:
                        let json = JSON(response.data!)
                        completion(json)
                        
                        break
                    case .failure(let error):
                        completion([
                                    "status":"failed",
                                    "message":"\(error.localizedDescription)"])
                        
                        break
                    }
                }
        } else {
            func_show_alert()
        }
        
    }
    
    class func postAPI_Image(_ url: String, _ imageData: Data?,
                             _ parameters: [String : String],
                             _ img_param:String, completion:@escaping ( _ json:JSON)->()) {
        if Reachability.isConnectedToNetwork() {
            let urlFull = URL (string: kBaseURL+url) /* your API url */
            
            let loginUserToken = UserDefaults.standard.value(forKey: kToken) as! String
            debugPrint(loginUserToken)
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data",
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json"
            ]
            
            //            let manager = Alamofire.SessionManager.default
            //            manager.session.configuration.timeoutIntervalForRequest = 80
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData {
                    multipartFormData.append(data, withName: img_param, fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            },
            usingThreshold: UInt64.init(), to: urlFull!, method: .post, headers: headers
            ) { (result) in
                switch result {
                case .success(let upload, _ , _):
                    upload.uploadProgress(closure: { (progress) in
                        
                    })
                    upload.responseJSON { response in
                        switch response.result {
                        case .success:
                            let json = JSON(response.data!)
                            completion(json)
                            break
                        case .failure(let error):
                            completion(["status":"failed","message":"\(error.localizedDescription)"])
                            break
                        }
                    }
                case .failure(let _):
                    break
                }
            }
        } else {
            func_show_alert()
        }
    }
    
    
    
    class func postAPI_Images(_ url: String,_ arrayImgData: [Data],
                              _ parameters: [String : Any],
                              _ httpHeaders:HTTPHeaders,
                              completion:@escaping ( _ json:JSON,_ status:String,_ message:String)->()) {
        //        if Reachability.isConnectedToNetwork() {
        //            let url = URL (string:kBaseURL+url) /* your API url */
        //
        //            let date = NSDate()
        //            let df = DateFormatter()
        //            df.dateFormat = "dd-mm-yy-hh-mm-ss"
        //
        //            let imageName = df.string(from: date as Date)
        //
        ////            let headers: HTTPHeaders = [
        ////                "Content-type": "multipart/form-data"
        ////            ]
        //            Alamofire.upload(multipartFormData: { (multipartFormData) in
        //                for (key, value) in parameters {
        //                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
        //                }
        //
        //                for i in 0..<arrayImgData.count {
        //                    multipartFormData.append(arrayImgData[i], withName: "photos[]",fileName: "image.png", mimeType: "image/png")
        //                }
        //            }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: httpHeaders) { (result) in
        //                switch result{
        //                case .success(let upload, _, _):
        //                    upload.responseJSON { response in
        //                        let json = JSON(response.data!)
        //                        let dict_json = json.dictionaryObject
        //                        if dict_json == nil {
        //                            completion(["status":"failed","message":"Video Not uploaded"],"failed","Video Not uploaded")
        //                        } else {
        //                            completion(json,"\(dict_json![status_resp]!)","\(dict_json![message_resp]!)")
        //                        }
        //                    }
        //                case .failure(let error):
        //                    completion(["status":"failed","message":"\(error.localizedDescription)"],"failed","\(error.localizedDescription)")
        //                }
        //            }
        //        } else {
        func_show_alert()
    }
    
    
    
    class func postAPI_Video(_ url: String, _ parameters: [String : String],
                             _ dictMedia_Param_Data:[String:Data],
                             completion:@escaping ( _ json:JSON)->()) {
        if Reachability.isConnectedToNetwork() {
            var loginUserToken = ""
            if let getToken = UserDefaults.standard.value(forKey: kToken) as? String {
                loginUserToken = getToken
            } else {
                SwiftMessageBar.showMessage(
                    withTitle: "Error! \n Token is empty",
                    message:"Login First",
                    type:.error
                )
                
                return
            }
            debugPrint(loginUserToken)
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data",
                "Content-Type":"application/x-www-form-urlencoded",
                "Authorization": "Bearer \(loginUserToken)",
                "Accept": "application/json",
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData : MultipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                for (params,dataMedia) in dictMedia_Param_Data {
                    
                    debugPrint(params)
                    debugPrint(dataMedia.count)
                    
                    if (params == "video") {
                        multipartFormData.append(dataMedia, withName:params, fileName: "video.mp4" , mimeType: "video/mp4")
                    } else if (params == "screenshot") {
                        multipartFormData.append(dataMedia, withName: params, fileName: "image.png", mimeType: "image/png")
                    } else if (params == "preview") {
                        multipartFormData.append(dataMedia, withName: params, fileName: "image.gif", mimeType: "image/gif")
                    }
                }
            },
            
            usingThreshold: UInt64.init(),
            to: kBaseURL+url,
            method: .post,
            headers: headers
            ) { (result) in
                switch result {
                case .success(let upload, _ , _):
                    upload.uploadProgress(closure: { (progress) in
                        
                    })
                    
                    upload.responseJSON { response in
                        let json = JSON(response.data!)
                        let dict_json = json.dictionaryObject
                        debugPrint(dict_json)
                        
                        if dict_json == nil {
                            completion(["status":"failed","message":"Video Not uploaded"])
                        } else {
                            if dict_json!.isEmpty {
                                completion(["status":"failed","message":"Video Not uploaded"])
                            } else {
                                completion(json)
                            }
                        }
                    }
                    
                case .failure(let _):
                    break
                }
            }
        } else {
            func_show_alert()
        }
        
    }
    
}


    
func func_show_alert() {
    SwiftMessageBar.showMessage(withTitle: "Error", message:"Internet Connection not Available!", type:.error)
}

enum status_type {
    case error_from_api
    case success
    case fail
}

func cleanJsonToObject(data : AnyObject) -> AnyObject {
    
    let jsonObjective : Any = data
    
    if jsonObjective is NSArray {
        let jsonResult : NSArray = (jsonObjective as? NSArray)!
        let array: NSMutableArray = NSMutableArray(array: jsonResult)
        
        for  i in stride(from: array.count-1, through: 0, by: -1)
        {
            let a : AnyObject = array[i] as AnyObject;
            
            if a as! NSObject == NSNull(){
                array.removeObject(at: i)
                
            } else {
                array[i] = cleanJsonToObject(data: a)
            }
        }
        return array;
    } else if jsonObjective is NSDictionary  {
        
        let jsonResult : Dictionary = (jsonObjective as? Dictionary<String, AnyObject>)!
        
        let dictionary: NSMutableDictionary = NSMutableDictionary(dictionary: jsonResult)
        
        //            let dictionary : NSMutableDictionary = (jsonResult as? NSMutableDictionary<String, AnyObject>)!
        
        for  key in dictionary.allKeys {
            
            let  d : AnyObject = dictionary[key as! NSCopying]! as AnyObject
            
            if d as! NSObject == NSNull()
            {
                dictionary[key as! NSCopying] = ""
            }
            else
            {
                dictionary[key as! NSCopying] = cleanJsonToObject(data: d )
            }
        }
        return dictionary;
    } else {
        return jsonObjective as AnyObject;
    }
    
}




