//
//  ViewController.swift
//  iOS_Final
//
//  Created by palak patel on 2022-08-12.
//

import UIKit
import FirebaseAuth
import Foundation

class WelcomeViewController: UIViewController {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadNews(search: "https://newsapi.org/v2/top-headlines?country=us&category=general&pageSize=50&apiKey=03a98aa3f1df40b7af382fd965a9d19d")
    }

    @IBAction func onNextTapped(_ sender: UIButton) {
        let Category=["business", "general", "sports"]
//
        let randomCategory=Category.randomElement()
//
        let Country=["ca","fr","us","lt","ma","mx","my","nl","no","tr","sk"]
        let randomCountry=Country.randomElement()
        
//    https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=03a98aa3f1df40b7af382fd965a9d19d
        loadNews(search: "https://newsapi.org/v2/top-headlines?country=\(randomCountry!)&category=\(randomCategory!)&pageSize=3&apiKey=03a98aa3f1df40b7af382fd965a9d19d")
    }
    
    
//    @IBAction func onLogoutTapped(_ sender: UIButton) {
//        let firebaseAuth = Auth.auth()
//
//        do{
//            try firebaseAuth.signOut()
//            dismiss(animated: true)
//
//        } catch let signOutError as NSError {
//            print("Sign out Error: \(signOutError)")
//        }
//}
//
    @IBAction func onLogoutTapped(_ sender: UIButton) {
                let firebaseAuth = Auth.auth()
        
                do{
                    try firebaseAuth.signOut()
                    dismiss(animated: true)
        
                } catch let signOutError as NSError {
                    print("Sign out Error: \(signOutError)")
                }}
    private func loadNews(search:String?){
        guard let search=search else{
            return
        }
        
        //step:1-get URL
        guard let url=getURL(query:search) else{
            print("couldn't get url")
            return
        }
        
        //step:2 create URLSession
        let session=URLSession.shared
        
        //step:3 create task for session
        let dataTask=session.dataTask(with: url) { data, response, error in
            //network call finished
            print("network call complete")
            
            guard error==nil else{
                print("error occurred")
                return
            }
            guard let data=data else{
                print("no data found")
                return
            }
            
            print(data.count)
            if let newsResponse=self.parseJson(data: data){
                DispatchQueue.main.async {
                    self.authorName.text=newsResponse.articles.first?.author
                    self.titleLabel.text=newsResponse.articles.first?.title
                    self.descriptionLabel.text=newsResponse.articles.first?.articleDescription
                    let imgURL=newsResponse.articles.first?.urlToImage
                    self.articleImage.load(urlString: imgURL!)
                    self.articleImage.layer.cornerRadius=20
                }
            }
            else{
                print("here......")
            }
        }
    
        
        //step:4 start the task
        dataTask.resume()
    
        
    }
    private func getURL(query:String)->URL?{
        
    let url = query
        print(url)
        return URL(string: url)
    }
    
    private func parseJson(data:Data)->NewsResponse?{
        let decoder=JSONDecoder()
        var news:NewsResponse?
        do{
            news=try decoder.decode(NewsResponse.self, from: data)
        }catch{
            print("Error Decoding")
        }
        return news
    }
    
}

struct NewsResponse: Decodable {
//    let status: String
//    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Decodable {
//    let url: String
    //    let publishedAt: Date
    //    let content: String
    let urlToImage: String
    let title:String
    let author:String
    
    let articleDescription:String
    
    enum CodingKeys: String, CodingKey {
           case author
           case title
           case articleDescription = "description"
           case urlToImage
//           case url, urlToImage, publishedAt, content
       }
}



