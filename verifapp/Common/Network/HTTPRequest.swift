//
//  HTTPRequest.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire
import SwiftyJSON
class HTTPRequestItem{
    var params = [String: Any]()
    var headerParams = HTTPHeaders()
    var httpRequestUrl = String()
    var httpRequestType = "POST"
    var httpTimeout = "2000"
    var EncodingType: ParameterEncoding = URLEncoding.httpBody
    //ALAMOFIRE WILL BE IMPLEMENTED UNDER
    init(){
        
    }
    init(httpRequestUrl: String){
        var NM = NetworkUtils()
        if (!NM.ifNotNullEmpty(text: httpRequestUrl)){
            print("Http request url can not be null")
            return
        }
        self.httpRequestUrl = httpRequestUrl
    }
    /**
     * Add single name-value pair for http param into [Map]
     *
     * @param key  name
     * @param value value
     */
    func addParams(key: String, Value: String){
        if(params.count == 0){
            //Perform action if parameters are null
        }
        params[key] = Value
    }
    /**
     * name-value pair for http header
     *
     * @param key  name
     * @param value value
     */
    func addHeaderParams(key: String, value: String){
        //headerParams[key] = value
        if(headerParams.count == 0){
            //Perform action if Header parameters are null
        }
        let hd = HTTPHeader(name: key, value: value)
        headerParams.update(hd)
    }
}
