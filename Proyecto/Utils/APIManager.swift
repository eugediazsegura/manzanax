//
//  APIManager.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 28/11/2021.
//
//
//  APIManager.swift
//  MyApp
//
//  Created by Jan Zelaznog on 07/11/21.
//
import Foundation
import SystemConfiguration

class APIManager {
    let baseURL = "https://raw.githubusercontent.com/beduExpert/Swift-Proyecto/main/API/db.json"
    
    static let shared = APIManager()
    
    func getMusic(completion: @escaping ([Track]?, Error?) -> ()) {
        let url : String = baseURL
        let request : NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string:  url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                 completion(nil, error!)
            }
            else {
                if let data = data {
                    do {
                        let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [ String : Any ]
                        let songs = dict["songs"] as! [[String:Any]]
                        let songsData = try JSONSerialization.data(withJSONObject: songs, options: .fragmentsAllowed)
                        let result = try JSONDecoder().decode([Track].self, from: songsData)
                        //misTracks = result
                     completion (result, nil)
                    }
                    catch {
                        print (String(describing: error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func checkConnectivity() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags : SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let connectedToInternet = (isReachable && !needsConnection)
        return connectedToInternet
    }
}
