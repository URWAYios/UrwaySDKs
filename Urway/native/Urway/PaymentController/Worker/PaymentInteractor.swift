
//
//  PaymentInteractor.swift
//  Urway
//
//  Copyright (c) 2020 URWAY. All rights reserved.

import UIKit
import CommonCrypto

protocol IPaymentInteractor: class {
    var parameters: [String: Any]? { get set }
    func postAPI(for model: UWInitializer)
}

var fullURL: String = ""


class PaymentInteractor: IPaymentInteractor {
    var presenter: IPaymentPresenter?
    var manager: IPaymentManager?
    var parameters: [String: Any]?
    
    var newURL: String = ""
    init(presenter: IPaymentPresenter, manager: IPaymentManager) {
        self.presenter = presenter
        self.manager = manager
    }
    
    
    func post(for model: UWInitializer) {
        var requestHash:String = ""
        var data: String = ""
        
        let terminalId : String = Common.Globle.terminalId
        let password : String = Common.Globle.password
        let merchantKey : String = Common.Globle.merchantKey
        
        let trackid :String = model.trackIdCode
        let merchantidentifier : String = model.merchantidentifier ?? ""
        let amount: String = model.amount
        let customerEmail: String = model.email
        let address: String = model.address ?? ""
        let city: String = model.city ?? ""
        let trackID: String = model.trackIdCode
        let udf1: String = model.udf1 ?? ""
        let udf2: String = model.udf2 ?? ""
        let udf3: String = model.udf3 ?? ""
        let udf4: String = model.udf4 ?? ""
        let udf5: NSString = model.udf5 ?? ""
        let action = model.actionCode
        let country: String = model.country
        let currency: String = model.currency
        let zipCode: String = model.zipCode ?? ""
        let tockenName: String = model.pickerType?.getValue() ?? ""
        let cardTocken: String = model.cardToken ?? ""
        let tokenizationType: String = model.tokenizationType ?? "0"
        let holderName: String = model.holderName ?? ""
        
        data = "\(trackid)|\(terminalId)|\(password)|\(merchantKey)|\(amount)|\(currency)"
        requestHash = sha256(str: data)
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache",
        ]
        
        let parameters = [
            "transid": "",
            "amount": amount,
            "address": address,
            "customerIp": "10.10.10.227",
            "city": city,
            "trackid": trackID,
            "terminalId": "\(terminalId)",
            "udf1": udf1,
            "udf2": udf2,
            "udf3": udf3,
            "udf4": udf4,
            "udf5": udf5,
            "applePayId": "\(merchantidentifier)",
            "action": action,
            "password": "\(password)",
            "merchantIp": "1.2.3.4",
            "requestHash": "\(requestHash)",
            "country": country,
            "currency": currency,
            "customerEmail": customerEmail,
            "zipCode": zipCode,
            "tokenOperation": tockenName,
            "cardToken": cardTocken,
            "tokenizationType": tokenizationType,
            "instrumentType" : "DEFAULT",
            "cardHolderName": holderName
            
            ] as [String : Any]
        
        
       
        print("request data ",parameters)
        let urlString = Common.Globle.url
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        do {
            let postData =  try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        }
        catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error == nil , let responceData = data {

                do {
                    guard let receivedTodo = try JSONSerialization.jsonObject(with: responceData, options: []) as? [String: Any] else { return  }
                    
                    if let targetURL = receivedTodo["targetUrl"] as? String{ self.newURL = targetURL }
                    
                    print("Dict ---->" , receivedTodo)

                    
                    if let result = receivedTodo["result"] as? String , result == "UnSuccessful" , let code =  receivedTodo["responsecode"] as? String , code != "000"{
                        self.presenter?.apiResult(result: .failure("\(code)"), responce: receivedTodo, error: error);
                        return
                    }else if let result = receivedTodo["result"] as? String , result == "Successful" , let code =  receivedTodo["responsecode"] as? String , code == "000"{
                        self.presenter?.apiResult(result: .sucess, responce: receivedTodo, error: error);
                        return
                    }
                    
                     
                    if let payID = receivedTodo["payid"] as? String{ self.newURL = "\(self.newURL)?paymentid=\(payID)" }
                    
                    if self.newURL.isEmpty , let code =  receivedTodo["responseCode"] as? String{
                        self.presenter?.apiResult(result: .failure("\(code)"), responce: receivedTodo, error: error);
                        return
                    }
                    
                       /*
                    if tockenName == "D" , let payID = receivedTodo["payid"] as? String{
                        
                        fullURL = "https://payments-dev.urway-tech.com/URWAYPGService/3DRedirect.jsp?paymentid=\(payID)"
                    } else {
                        fullURL = self.newURL
                    }*/
                    
                    if tockenName == "D"{
                        if let payID = receivedTodo["payid"] as? String{
                            self.newURL = "\(self.newURL)?paymentid=\(payID)"
                            fullURL = "\(self.newURL)\(payID)"
                        }else{
                            fullURL = self.newURL
                        }
                        //fullURL = "https://payments-dev.urway-tech.com/URWAYPGService/3DRedirect.jsp?paymentid=\(payID)"
                    } else {
                        fullURL = self.newURL
                    }
                    
                    print("the url is : \(fullURL)")

                    
                    self.presenter?.apiResult(result: .sucess, responce: receivedTodo, error: error)
                    
                }
                catch  {
                    print("error parsing response from POST on /todos")
                    return
                }
            }
            
            
        })
        
        dataTask.resume()
        
        
    }
    
    func postAPI(for model: UWInitializer) {
        self.post(for: model)
     }
    
}


extension PaymentInteractor {
    
    func sha256(str: String) -> String {
        
        if let strData = str.data(using: String.Encoding.utf8) {
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
            strData.withUnsafeBytes {
                CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
            
            var sha256String = ""
            for byte in digest {
                sha256String += String(format:"%02x", UInt8(byte))
            }
            
            
            if sha256String.uppercased() == "E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188" {
                print("Matching sha256 hash: E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188")
            } else {
                print("sha256 hash does not match: \(sha256String)")
            }
            return sha256String
        }
        return ""
    } 
    
}


