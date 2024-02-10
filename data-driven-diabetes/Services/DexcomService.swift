//
//  DexcomService.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import UIKit
import SafariServices

class DexcomService {
    private let apiUrl = "https://sandbox-api.dexcom.com"
    private let clientId = "dub6uFaRhftPedGRuNt2AeB7iECDpnVM"
    private let clientSecret = "rEYDS3FUQYQCL6Rp"
    private let redirectUri = "data-driven-diabetes://oauth-callback"
    private let authorizationEndpoint = "https://api.dexcom.com/v2/oauth2/login"
    private let tokenEndpoint = "https://api.dexcom.com/v2/oauth2/token"
    
    // change

    private var authorizationCode: String?

    @IBAction func connectToDexcomPressed(_ sender: Any) {
        var components = URLComponents(string: authorizationEndpoint)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "offline_access")
        ]

        let url = components.url!
        let safariVC = SFSafariViewController(url: url)
        UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true, completion: nil)
    }

    // Call this method to handle the redirect URI with the authorization code
    func handleRedirectUri(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            print("Error retrieving authorization code")
            return
        }

        self.authorizationCode = code
        requestAccessToken()
    }

    // Define a struct to parse the token response
    struct TokenResponse: Codable {
        let accessToken: String
        let expiresIn: Int
        let refreshToken: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case refreshToken = "refresh_token"
        }
    }
    
    func requestAccessToken() {
        guard let url = URL(string: tokenEndpoint),
              let code = self.authorizationCode else {
            print("Authorization code not available")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectUri,
            "client_id": clientId,
            "client_secret": clientSecret
        ]
        request.httpBody = parameters.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(TokenResponse.self, from: data)
                print("Access Token: \(responseObject.accessToken)")
            } catch {
                print("Error decoding token response: \(error)")
            }
        }

        task.resume()
    }


    func fetchEGVs(startDate: String, endDate: String, completion: @escaping (Result<EGV, Error>) -> Void) {
//        return EGV
        
    }
}
