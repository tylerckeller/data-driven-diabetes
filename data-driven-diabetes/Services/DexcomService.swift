//
//  DexcomService.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//
import Foundation
import OAuthSwift
import WebKit

class DexcomOAuthWebViewController: OAuthWebViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
    }

    override func handle(_ url: URL) {
        let req = URLRequest(url: url)
        self.webView.load(req)
    }
}


class DexcomService {
    private let apiUrl = "https://sandbox-api.dexcom.com"
    private let clientId = "dub6uFaRhftPedGRuNt2AeB7iECDpnVM"
    private let clientSecret = "rEYDS3FUQYQCL6Rp"
    private let redirectUri = "data-driven-diabetes://oauth-callback"
    private let authorizationEndpoint = "https://api.dexcom.com/v2/oauth2/login"
    

    func connectToDexcomPressed(_ sender: Any) {
        var oauthswift = OAuth2Swift(
            consumerKey:    clientId,
            consumerSecret: clientSecret,
            authorizeUrl:   authorizationEndpoint,
            responseType:   "token"
        )
        
        oauthswift.authorizeURLHandler = DexcomOAuthWebViewController()
        
        let handle = oauthswift.authorize(
            withCallbackURL: "oauth-swift://oauth-callback/instagram",
            scope: "likes+comments", state:"INSTAGRAM") { result in
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
        
    }
}
