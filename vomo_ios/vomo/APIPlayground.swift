//
//  APIPlayground.swift
//  VoMo
//
//  Created by Neil McGrogan on 4/5/22.
//

import SwiftUI
import Foundation

struct ExerciseList: View {
    
    var body: some View {
        Text("hello")
    }
}

struct APIPlayground: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    func post() {
        guard let url = URL (string: "https://redcap.research.cchmc.org/api/") else {return}
        let token = "D0F3C8433740FCE1BC103C25BADDEA6C" // unique to REDCap project
        let record = "3" // set elsewhere
        let event = ""
        let field = "VoMo" // name of field in REDCap
        let path = "path_of_file_to_be_uploaded"
        let repeat_instance : Int = 1
         
        let parameters = [
            [
            "key": "token",
            "value": token,
            "type": "text"
            ],
            [
            "key": "content",
            "value": "file",
            "type": "text"
            ],
            [
            "key": "action",
            "value": "import",
            "type": "text"
            ],
            [
            "key": "record",
            "value": record,
            "type": "text"
            ],
            [
            "key": "field",
            "value": field,
            "type": "text"
            ],
            [
            "key": "event",
            "value": event,
            "type": "text"
            ],
            [
            "key": "repeat_instance",
            "value": repeat_instance,
            "type": "text"
            ],
            [
            "key": "returnFormat",
            "value": "json",
            "type": "text"
            ],
            [
            "key": "file",
            "src": path,
            "type": "file"
        ]] as [[String : Any]]
         
        // build payload
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in parameters {
        if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
                body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                //let paramValue = param["value"] as! String
                let paramValue = param["value"]
                body += "\r\n\r\n\(String(describing: paramValue))\r\n"
            } else {
                let paramSrc = param["src"] as! String
                let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data
                //let fileContent = String(data: fileData!, encoding: .utf8)!
                let fileContent = String(data: fileData ?? Data(), encoding: .utf8)!
                body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
         
        // create URL request and session
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
         
        request.httpMethod = "POST"
        request.httpBody = postData
         
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("REDCap")
                .font(.title)
           
            Divider()
            
            Button(action: {
                print("send data to redcap")
                post()
            }) {
                VStack {
                    Text("send data to REDCap")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(10)
                }
                .background(Color.red)
                .cornerRadius(15)
                .padding(.bottom, 100)
            }
            .padding(.top)
            
            //WavPlayground()
        }
    }
}

struct APIPlayground_Previews: PreviewProvider {
    static var previews: some View {
        APIPlayground()
    }
}

