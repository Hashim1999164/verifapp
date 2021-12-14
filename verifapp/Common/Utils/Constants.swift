//
//  Constants.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.


import Foundation

struct Constants {
    //live server adress
    let SOCKET_SERVER = "http://3.12.71.28"
    let BASE_API_SERVER = "https://api2.verifapp.com/"
    //     let BASE_API_SERVER_WITH_PORT = "$BASE_API_SERVER:9443"
    let BASE_API_SERVER_WITH_PORT = "https://api2.verifapp.com/"
    let API_SERVER: String!
    
    
    
    //     let SOCKET_SERVER = "http://192.168.3.51:3030"
    //     let API_SERVER = "http://192.168.3.51:3030/otp/v1"
    
    let API_OSP: String!
    
    //region SMS
    //sms to server
    let API_SMST: String!
    let API_SMST_VERIFY: String!
    
    //Self SMS
    let API_SSMS: String!
    let API_SSMS_VERIFY: String!
    
    //Sms from server
    let API_SMSF: String!
    let API_SMSF_VERIFY: String!
    let API_SMSF_PERMISSION: String!
    let API_SMSF_PERMISSION_VERIFY: String!
    let API_SMSF_NONPERMISSION: String!
    let API_SMSF_NONPERMISSION_VERIFY: String!
    //end region
    
    //Sms from WhatsApp
    let API_WHATSAPP: String!
    let API_WHATSAPP_VERIFY: String!
    let API_WHATSAPP_PERMISSION: String!
    let API_WHATSAPP_PERMISSION_VERIFY: String!
    let API_WHATSAPP_NONPERMISSION: String!
    let API_WHATSAPP_NONPERMISSION_VERIFY: String!
    //end region
    
    //start region Call
    let API_FCFS: String!
    let API_FCFS_VERIFY: String!
    let API_FCFS_PERMISSION: String!
    let API_FCFS_PERMISSION_VERIFY: String!
    let API_FCFS_NONPERMISSION: String!
    let API_FCFS_NONPERMISSION_VERIFY: String!
    
    let API_FCTS: String!
    let API_FCTS_VERIFIY: String!
    //endregion
    
    //start region access token
    let API_REQUEST_NEW_ACCESS_TOKEN_GRANT: String!
    let API_UPDATE_ACCESS_TOKEN: String!
    
    let OTP_EXPIRES_IN: Int64 = 10 * 1000
    
    let PERMISSION_SEND_SMS: Int!
    let PERMISSION_READ_SMS: Int!
    let PERMISSION_RECEIVE_SMS: Int!
    let PERMISSION_CALL_PHONE: Int!
    let PERMISSION_READ_PHONE_STATE: Int!
    let PERMISSION_PROCESS_OUTGOING_CALLS: Int!
    let PERMISSION_STARTUP_PERMISSION: Int!
    init(){
        API_SERVER = BASE_API_SERVER_WITH_PORT + "app/1/"
        API_OSP = API_SERVER + "$API_SERVER/osp"
        API_SMST = API_SERVER + "$API_SERVER/sms/to"
        API_SMST_VERIFY = API_SERVER + "$API_SERVER/sms/to/received"
        API_SSMS = API_SERVER + "$API_SERVER/sms"
        API_SSMS_VERIFY = API_SERVER + "$API_SERVER/sms/verify"
        API_SMSF = "/sms/from"
        API_SMSF_VERIFY = API_SERVER + "/sms/from/verify"
        API_SMSF_PERMISSION = API_SERVER + "app-permission/1/sms/from"
        API_SMSF_PERMISSION_VERIFY = API_SERVER + "app-permission/1/sms/from/verify"
        API_SMSF_NONPERMISSION = API_SERVER + "app-nonpermission/1/sms/from"
        API_SMSF_NONPERMISSION_VERIFY = API_SERVER + "app-nonpermission/1/sms/from/verify"
        API_WHATSAPP = "/wb/sms"
        API_WHATSAPP_VERIFY = API_SERVER + "/wb/sms/verify"
        API_WHATSAPP_PERMISSION = BASE_API_SERVER_WITH_PORT + "app-permission/1/wb/sms"
        API_WHATSAPP_PERMISSION_VERIFY = BASE_API_SERVER_WITH_PORT + "app-permission/1/wb/sms/verify"
        API_WHATSAPP_NONPERMISSION = BASE_API_SERVER_WITH_PORT + "app-nonpermission/1/wb/sms"
        API_WHATSAPP_NONPERMISSION_VERIFY = BASE_API_SERVER_WITH_PORT + "app-nonpermission/1/wb/sms/verify"
        API_FCFS = API_SERVER + "$API_SERVER/call/from"
        API_FCFS_VERIFY = API_SERVER + "$API_SERVER/call/from/verify"
        API_FCFS_PERMISSION = BASE_API_SERVER_WITH_PORT + "app-permission/1/call/from"
        API_FCFS_PERMISSION_VERIFY = BASE_API_SERVER_WITH_PORT + "app-permission/1/call/from/verify"
        API_FCFS_NONPERMISSION = BASE_API_SERVER_WITH_PORT + "app-nonpermission/1/call/from"
        API_FCFS_NONPERMISSION_VERIFY = BASE_API_SERVER_WITH_PORT + "app-nonpermission/1/call/from/verify"
        API_FCTS = API_SERVER + "$API_SERVER/call/to"
        API_FCTS_VERIFIY = API_SERVER + "$API_SERVER/call/to/received"
        API_REQUEST_NEW_ACCESS_TOKEN_GRANT = BASE_API_SERVER + "token"
        API_UPDATE_ACCESS_TOKEN = BASE_API_SERVER + "token"
        self.PERMISSION_SEND_SMS = 0
        self.PERMISSION_READ_SMS = 1
        self.PERMISSION_RECEIVE_SMS = 2
        self.PERMISSION_CALL_PHONE = 3
        self.PERMISSION_READ_PHONE_STATE = 4
        self.PERMISSION_PROCESS_OUTGOING_CALLS = 5
        self.PERMISSION_STARTUP_PERMISSION = 6
        
        
        
    }
}

