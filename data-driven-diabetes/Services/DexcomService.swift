//
//  DexcomService.swift
//  data-driven-diabetes
//
//  Created by Tyler Keller on 2/10/24.
//

import Foundation
import UIKit
import SafariServices

class OAuthViewController: UIViewController {
    private let apiUrl = "https://sandbox-api.dexcom.com"
    //DEV CHANGE
    //private let apiUrl = "http://138.67.183.114:3000"
    
    // Replace these with your client's details
    private let clientId = "dub6uFaRhftPedGRuNt2AeB7iECDpnVM"
    private let clientSecret = "rEYDS3FUQYQCL6Rp"
    private let redirectUri = "YOUR_APP_SCHEME://oauth-callback"
    private let authorizationEndpoint = "https://api.dexcom.com/v2/oauth2/login"
    private let tokenEndpoint = "https://api.dexcom.com/v2/oauth2/token"

    private var authorizationCode: String?

    @IBAction func connectToDexcomPressed(_ sender: Any) {
        var components = URLComponents(string: authorizationEndpoint)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "offline_access"),
            URLQueryItem(name: "state", value: "yourStateValue") // Generate a secure random state
        ]

        let url = components.url!
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
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

    private func requestAccessToken() {
        guard let url = URL(string: tokenEndpoint),
              let code = self.authorizationCode else { return }

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
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                print("Error requesting access token")
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(TokenResponse.self, from: data)
                // Here, save the access and refresh tokens securely (e.g., Keychain)
                print("Access Token: \(responseObject.accessToken)")
            } catch {
                print("Error decoding token response: \(error.localizedDescription)")
            }
        }

        task.resume()
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

    // Add methods to refresh the access token using the refresh token
    // and to revoke tokens if needed, following a similar pattern.
    
    func fetchEGVs(startDate: String, endDate: String, completion: @escaping (Result<[EGV], Error>) -> Void) {
        guard let url = URL(string: "\(apiUrl)/egvs") else {
            completion(.failure(NSError(domain: "DealService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                completion(.failure(NSError(domain: "DealService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "DealService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])))
//                return
//            }
//            
//            do {
//                let deals = try JSONDecoder().decode([Deal].self, from: data)
//                completion(.success(deals))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
    }
}

