//
//  LoggerPlugin.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import Foundation
import Moya

final class LoggerPlugin: PluginType {
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
            case .success(let response):
                guard let request = response.request else { return }
                
                let logSuccessMessage = "\n✅ Request sent seccessfully \n🚀 Request: \(request)\n"
                print(logSuccessMessage)
                
            case .failure(let error):
                let logFailureMessage = "\n❌ Error: \(error.localizedDescription)\n"
                print(logFailureMessage)
        }
    }
}
