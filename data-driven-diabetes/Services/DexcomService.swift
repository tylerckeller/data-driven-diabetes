//
//  DexcomService.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//
import Foundation
import OAuthSwift
import WebKit

//class DexcomOAuthWebViewController: OAuthWebViewController {
//    lazy var webView: WKWebView = {
//        let configuration = WKWebViewConfiguration()
//        // Configure your webView if needed
//        return WKWebView(frame: self.view.bounds, configuration: configuration)
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(self.webView)
//    }
//
//    override func handle(_ url: URL) {
//        let req = URLRequest(url: url)
//        self.webView.load(req)
//    }
//}



class DexcomService {
    private let apiUrl = "https://sandbox-api.dexcom.com"
    private let clientId = "dub6uFaRhftPedGRuNt2AeB7iECDpnVM"
    private let clientSecret = "zWCSnPB7bJON41IN"
    private let redirectUri = "https://www.tylerkeller.dev/oauth-callback"
    private let authorizationEndpoint = "https://sandbox-api.dexcom.com/v2/oauth2/login"
    

    func connectToDexcomPressed() {
        let oauthswift = OAuth2Swift(
            consumerKey:    clientId,
            consumerSecret: clientSecret,
            authorizeUrl:   authorizationEndpoint,
            responseType:   "token"
        )
        
//        oauthswift.authorizeURLHandler = DexcomOAuthWebViewController()
        
        let handle = oauthswift.authorize(
            withCallbackURL: redirectUri,
            scope: "", state:"") { result in
            switch result {
            case .success(let (credential, response, parameters)):
              print(credential.oauthToken)
              // Do your request
            case .failure(let error):
              print(error.localizedDescription)
            }
        }
    }

    func fetchEGVs(startDate: String, endDate: String, completion: @escaping (Result<EGV, Error>) -> Void) {
//        return EGV
        guard let url = URL(string: "\(apiUrl)/your_endpoint_here?startDate=\(startDate)&endDate=\(endDate)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add any necessary headers, e.g., Authorization with the bearer token
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                // Assuming `GlucoseRecord` conforms to Decodable
                let egv = try JSONDecoder().decode(EGV.self, from: data)
                completion(.success(egv))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
