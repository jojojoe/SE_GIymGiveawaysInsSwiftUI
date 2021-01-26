//
//  UserModel.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/20.
//

import Foundation
import SwiftyJSON
import Alamofire

 


class UserModelRequest: ObservableObject {
    
    static let `default` = UserModelRequest()
    
    @Published var postUrl: String = ""
    @Published var winnerCount: String = ""
    @Published var substitutesCount: String = ""
    
    @Published var edges: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]? = nil
//    @Published var user: UserInfoModel.Graphql.User? = nil
    
    @Published var winner: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]?
    @Published var substitutes: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]?
    
    @Published var userInfo: GIUserInfoDes = GIUserInfoDes.init(userID: "", postUrlStr: "", userProfileUrlStr: "", commendCount: "", loveCount: "")
    
    
    var reaginCount = 0
    
    @Published var pasteboardString: String = ""
    
    init() {
        NotificationCenter.default.addObserver(self, selector:#selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        //注册进入后台的通知
        NotificationCenter.default.addObserver(self, selector:#selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)

    }
    
    //必须要加@objc-----进入前台
    @objc  func becomeActive(noti:Notification){
        readPasteboard()
    }
    //必须要加@objc----进后台
    @objc  func becomeDeath(noti:Notification){
        
        
    }
    
    func request(urlstr: String, completion: @escaping (_ success: Bool, _ edges: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]?, _ user: GIUserInfoDes?)-> Void) {
        
        let uppwer = urlstr.range(of: "https://www.instagram.com/p/")
        
        let lower = urlstr.range(of: "/?igshid=")
        guard  let upperBound =  uppwer?.upperBound,let lowerBound = lower?.lowerBound else {
            completion(false, nil, nil)
            return
        }
        
        let subStr =  urlstr[upperBound..<lowerBound]
    
        let shortcode = String(subStr)
        
        let reqstURL =   "https://www.instagram.com/p/\(shortcode)/?__a=1"
        
//                "https://www.instagram.com/graphql/query/?query_hash=\(queryHash)&variables=\(variables ?? "")"
        guard let url = URL(string: reqstURL) else {
            completion(false, nil, nil)
            return
        }
        
        
        
        AF.request(url, method: .get, parameters: nil, headers: nil).responseJSON { (response) in
            
            let json = response.data?.string(encoding: .utf8)
            guard let fetcdata = response.data else {
                completion(false, nil, nil)
                return
            }
            //
            do {
                
                var model = try JSONDecoder().decode(UserInfoModel.self, from: fetcdata)
                model.jsonData = try JSON(data: fetcdata)
                  guard model.graphql?.user?.id?.count ?? 0 > 0 else {
                    completion(false, nil, nil)
                    return
                  }
                guard let edgesNo = model.graphql?.user?.edgeMediaToParentComment?.edges?.map({$0})  else {
                    completion(false, nil, nil)
                    return
                }
                debugPrint(edgesNo)
                
                self.postUrl = model.graphql?.user?.displayUrl?.absoluteString ?? ""
                
                self.edges = model.graphql?.user?.edgeMediaToParentComment?.edges
                
                let postUrl_m = model.graphql?.user?.displayUrl?.absoluteString ?? ""
                let userProfile = model.graphql?.user?.profilePicUrl?.absoluteString ?? ""
                let commentCount = "\(model.graphql?.user?.edgeMediaToParentComment?.count ?? 0)"
                let loveCount = "\(model.graphql?.user?.edgeMediaPreviewLike?.count ?? 0)"
                let info = GIUserInfoDes(userID: model.graphql?.user?.id ?? "", postUrlStr: postUrl_m, userProfileUrlStr: userProfile, commendCount: commentCount, loveCount: loveCount)
                self.userInfo = info
//                self.user = model.graphql?.user
                
                completion(true, self.edges, self.userInfo)
               
            } catch {
                debugPrint(error)
                self.reaginCount = self.reaginCount+1
                if self.reaginCount >= 3 {
                    self.reaginCount = 0
                    self.failedNextRequest(shortcode: shortcode) { (success, edges, user) in
                        self.edges = edges
                        if let user_m = user {
                            self.userInfo = user_m
                        }
                        
                        completion(success, edges, self.userInfo)
                    }
                } else {
                    self.request(urlstr: urlstr, completion: completion)
                }
            }
        }
    }
    
    func failedNextRequest(shortcode:String,closure:@escaping(_ success: Bool, _ edges:[UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]?, _ user: GIUserInfoDes?) -> Void) {
        let nexpraram = [
            "shortcode":shortcode,
            "first":"400",
            "after":""
        ]

        let nexpinCode =  nexpraram.jsonString()
        let nexvariables =  nexpinCode?.urlEncoded
        let nexreqstURL =   "https://www.in\("stag")ram.com/graphql/query/?query_hash=bc3296d1ce80a24b1b6e40b1e72903f5&variables=\(nexvariables ?? "")"
        guard let nexurl = URL(string: nexreqstURL) else {
            closure(false, nil, nil)
            return
        }
        AF.request(nexurl, method: .get, parameters: nil, headers: nil).responseJSON { (response) in
            debugPrint(response.value ?? "")
            guard let rdata = response.data else {
                closure(false, nil, nil)
                return
            }
            
            do {

                let json = try JSON(data: rdata)
                guard let data =  try? json["data"].rawData()  else {
                    closure(false, nil, nil)
                    return
                }

                let model = try JSONDecoder().decode(UserInfoModel.Graphql.self, from: data)
                guard let edges = model.user?.edgeMediaToParentComment?.edges?.map({$0})  else {
                    closure(false, nil, nil)
                    return
                }
                debugPrint(edges)
                
                let postUrl_m = model.user?.displayUrl?.absoluteString ?? ""
                let userProfile = model.user?.profilePicUrl?.absoluteString ?? ""
                let commentCount = "\(model.user?.edgeMediaToParentComment?.count ?? 0)"
                let loveCount = "\(model.user?.edgeMediaPreviewLike?.count ?? 0)"
                let info = GIUserInfoDes(userID: model.user?.id ?? "", postUrlStr: postUrl_m, userProfileUrlStr: userProfile, commendCount: commentCount, loveCount: loveCount)
                closure(true, edges, info)
                
            } catch {
                closure(false, nil, nil)
                debugPrint(error)
            }
        }
    }
}

extension UserModelRequest {
    func filterWinnersAndSubstitutes(winnerCount: Int, substitutesCount: Int, tagsCount: Int) {
        
        var filterEdge: [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?] = edges ?? []
        
        if tagsCount != 0 {
            filterEdge = []
            edges?.forEach({ (edge) in
                if let count = edge?.node?.text?.count(of: "#") {
                    if count == tagsCount {
                        filterEdge.append(edge!)
                    }
                    debugPrint(count)
                }
            })
        }
        
        let edges_removeMaster = filterEdge.filter { (edges) -> Bool in
            edges?.node?.owner?.id != self.userInfo.userID
        }
        let edges_filtered = edges_removeMaster.filterDuplicates({$0?.node?.owner?.id})
        
        
        
        let winner = edges_filtered.sample(size: winnerCount,noRepeat: true)
        var  unLastSubstitutes = [UserInfoModel.Graphql.User.EdgeMediaToParentComment.Edges?]()
        if edges_filtered.count > winnerCount {
            unLastSubstitutes  = edges_filtered.filter { edgew in
               return !(winner?.contains(where: { (edge) -> Bool in
                    return  edgew?.node?.owner?.id == edge?.node?.owner?.id
                }) ?? false)
            }
        }
     
        let substitutes =  unLastSubstitutes.sample(size: substitutesCount,noRepeat: true)
        
        self.winnerCount = "\(winner?.count ?? 0)"
        self.substitutesCount = "\(substitutes?.count ?? 0)"
        
        self.winner = winner
        self.substitutes = substitutes
        
        var winnerDictList: [[String : String]] = []
        if let winner_m = winner {
            var dict: [String : String] = [:]
            for item in winner_m {
                let profile = item?.node?.owner?.profilePicUrl?.absoluteString ?? ""
                let userName = item?.node?.owner?.username ?? ""
                let prize = DataManager.default.currentSelectPrize
                
                dict = ["userIcon": profile,"userName": userName,"prize": prize]
                winnerDictList.append(dict)
            }
        }
        
        var substitutesDictList: [[String : String]] = []
        if let substitutes_m = substitutes {
            var dict: [String : String] = [:]
            for item in substitutes_m {
                let profile = item?.node?.owner?.profilePicUrl?.absoluteString ?? ""
                let userName = item?.node?.owner?.username ?? ""
                let prize = DataManager.default.currentSelectPrize
                
                dict = ["userIcon": profile,"userName": userName,"prize": prize]
                substitutesDictList.append(dict)
            }
        }
        
        
        HistoryManager.default.addHistory(postUrl: postUrl, prize: DataManager.default.currentSelectPrize, winners: winnerDictList, substitutes: substitutesDictList)
        
        
    }
    
    
    func readPasteboard() -> String {
        let pasteboard = UIPasteboard.general
        if let string = pasteboard.string {
            if !(string.contains("https://www.in\("stag")ram.com/p/") ) &&
                !(string.contains("/?igshid=") ) {
                return ""
            } else {
                pasteboardString = string
                return string
            }
        } else {
            return ""
        }
    }
    
}

 
 
public protocol MLJSONObject: Codable {
    var jsonData: JSON? { get set }
}

extension MLJSONObject {

}

public struct UserInfoModel: MLJSONObject {
    public var jsonData: JSON?
//    public var cookies: FireCookies?

//    public var UserInfoUserJSON: JSON? {
//        let value = jsonData?["entry_data"]["ProfilePage"].first?.1["graphql"]["user"]
//        return value
//    }

    private enum CodingKeys: String, CodingKey {
        case jsonData
        case graphql
//        case cookies
//        case entryData = "data"
    }

//    public struct EntryData: Codable {
//        public struct ProfilePage: Codable {
            public struct Graphql: Codable {
                public struct User: Codable {
                    public var id: String?
//                    public var owner: Owner?
                    public struct Owner: Codable {
                        public var id: String?
                        public var username: String?
                        public var profilePicUrl:URL?
                        private enum CodingKeys: String, CodingKey {
                            case profilePicUrl = "profile_pic_url"
                            case id = "id"
                            case username = "username"
                        }

                    }
                    public var profilePicUrl: URL?
//                    public var externalUrlLinkshimmed: URL?
//                    public var fullName: String?
//                    public var edgeFollowBy: EdgeFoll?
//                    public var edgeFollow: EdgeFoll?
//                    public var biography:String?
                    public struct EdgeFoll: Codable {
                       public var count: Int?
                   }
//
                
                    public var edgeMediaToParentComment: EdgeMediaToParentComment?
                    public var edgeMediaToCaption: EdgeMediaToCaption?
                    public var edgeMediaPreviewLike:EdgeFoll?
                    public var displayUrl:URL?
                    public struct EdgeMediaToCaption: Codable {
                        public struct Edges: Codable {
                            public struct Node: Codable {
                                public var text: String?
                              
                            }

                            public var node: Node?
                        }

                        public var edges: [Edges]?
                    }
                    
                    public struct EdgeMediaToParentComment: Codable {
                        public struct Edges: Codable {
                            public struct Node: Codable {
                                public var text: String?
                                public var owner:Owner?
                            }

                            public var node: Node?
                        }

                        public var edges: [Edges]?
                        public var count: Int?
                    }
                    
                   
//
//
//                    public var profilePicUrlHd: URL?
//                    public var externalUrl: URL?
//                    public var username: String?
//                    public var isPrivate: Bool?
                    private enum CodingKeys: String, CodingKey {
                        case profilePicUrl = "profile_pic_url"
//                        case externalUrlLinkshimmed = "external_url_linkshimmed"
//                        case fullName = "full_name"
//                        case profilePicUrlHd = "profile_pic_url_hd"
//                        case externalUrl = "external_url"
//                        case username
                        case id
//                        case biography
//                        case isPrivate = "is_private"
//                        case edgeFollowBy = "edge_followed_by"
//                        case edgeFollow = "edge_follow"
                        case edgeMediaToCaption = "edge_media_to_caption"
                        case edgeMediaToParentComment = "edge_media_to_parent_comment"
                        case edgeMediaPreviewLike = "edge_media_preview_like"
                        case displayUrl = "display_url"
//                        case owner = "owner"
                    }
                }

                public var user: User?
//
                private enum CodingKeys: String, CodingKey {
                    case user = "shortcode_media"
                }
            }
//
            public var graphql: Graphql?
//        }
//
//        public var profilePage: [ProfilePage]?
//        private enum CodingKeys: String, CodingKey {
//            case profilePage = "PostPage"
//
//        }
//    }

//    public var entryData: EntryData?
}

struct GIUserInfoDes {
    var userID: String
    var postUrlStr: String
    var userProfileUrlStr: String
    var commendCount: String
    var loveCount: String
}
