//
//  NetworkUtils.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
class NetworkUtils {
    /*
     A Session Singleton Instance for Alamofire Api Calls
     */
    private var Manager: Session?
    
    private func sessionConfig() -> URLSessionConfiguration{
        let Configuration = URLSessionConfiguration.default
        Configuration.timeoutIntervalForRequest = 10
        return Configuration
    }
    
    
    /**
     * This method takes [HttpRequestItem] as a input.
     * Get below values from [HttpRequestItem]
     * 1.  HTTP_GET or HTTP_POST
     * 2.  Http service/api name via [HttpRequestItem.httpRequestUrl]
     * 3.  Initialize http connection using [.initHttpURLConnection]
     * 4.  Read and return response from [HttpURLConnection] via [.getHttpURLConnectionResponse]
     *
     * @param params [HttpRequestItem]
     * @completion network response ANY
     */
    func executeNetworkRequest(params: HTTPRequestItem, completion: @escaping(HttpResponseItem) -> ()){
        Manager = Session(configuration: sessionConfig())
        Manager?.request(params.httpRequestUrl, method: .post, parameters: params.params, encoding: params.EncodingType, headers: params.headerParams).responseJSON{ response in
            switch response.result {
            case .success(let value):
                completion(self.getHttpURLConnectionResponse(response: value as! [String: Any], responseCode: response.response!.statusCode))
            case .failure(let error):
                print(error)
                completion(HttpResponseItem())
            }
        }
        
    }
    /**
     * Check for http data/response validity if its valid return formatted json response
     * otherwise check for some basic errors and return with HttpURLConnection error code
     * and custom error message.
     *
     * @param connection HttpURLConnection
     * @return formatted json response
     */
    
    // DEPRECATED !!!!! Confused still!
    func getHttpURLConnectionResponse(response: [String: Any],responseCode: Int) -> HttpResponseItem {
        let Response = HttpResponseItem()
        //return successfull response
        Response.responseCode = responseCode
        Response.response = response
        //Response.otpLevel
        return Response
        //Return Null if every case fails!
    }
    func getAllTrustCertificates() -> [ServerTrustManager] {
        return [ServerTrustManager]()
    }
    /**
     * Create [HttpURLConnection] from [HttpRequestItem].
     * Steps:
     * 1.   Read request type.
     * 2.   For HTTP_GET append params into given url using [.getQueryParams]
     * 3.   For HTTP_POST add params into [HttpURLConnection.getOutputStream] via [DataOutputStream]
     *
     * @param params  [HttpRequestItem]
     * @param charset [URLEncoder]
     * @return HttpURLConnection
     * @throws IOException exception
     */
    private func initHttpURLConnection(params: HttpResponseItem, charset: String) {
        
    }
    /**
     * Create a default/generic response using response code and Http response string
     *
     * @param data         String response from [HttpURLConnection.getInputStream]
     * @param responseCode [HttpURLConnection.getResponseCode]
     * @return Formatted json response
     */
    private func getResponseMessage(data: String, responseCode: Int) -> String{
        return ""
    }
    /**
     * @param map     [java.util.HashMap] contains name-value pair of http prams like name=john doe
     * @param charset [URLEncoder]
     * @return formatted query params
     * @throws UnsupportedEncodingException Exception while parsing params
     */
    private func getQueryParams() -> String{
        return ""
    }
    func convertInputStreamToString(stream: InputStream) -> String {
        return ""
    }
    /**
     * Add header params via [HttpURLConnection.addRequestProperty]
     *
     * @param connection [HttpURLConnection]
     * @param map        [Map] name-value pair params
     * @throws UnsupportedEncodingException exception while parsing
     */
    private func setHeaderParams(){
        
    }
    
    func ifNotNullEmpty(text: String?) -> Bool {
        return (text != nil && ((text?.isEmpty) != nil))
    }
    
}
