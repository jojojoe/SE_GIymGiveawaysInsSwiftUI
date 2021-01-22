//
//  HistoryManager.swift
//  GIymGiveawaysIns
//
//  Created by JOJO on 2021/1/22.
//

import Foundation
import SQLite

struct HistoryWinnerItem {
    var userIcon: String = ""
    var userName: String = ""
    var prize: String = ""
    init(userIcon: String, userName: String, prize: String) {
        self.userIcon = userIcon
        self.userName = userName
        self.prize = prize
    }
    
    init(dict: [String: String]) {
        self.userIcon = dict["userIcon"] ?? ""
        self.userName = dict["userName"] ?? ""
        self.prize = dict["prize"] ?? ""
    }
}

class HistoryItem: Identifiable, ObservableObject {
    var id: Int = 0
    var postUrl: String = ""
    var prize: String = ""
    var winners: [HistoryWinnerItem] = []
    var substitutes: [HistoryWinnerItem] = []
    
    
    init(id: Int, postUrl: String, prize: String, winners: [HistoryWinnerItem], substitutes: [HistoryWinnerItem]) {
        self.id = id
        self.postUrl = postUrl
        self.prize = prize
        self.winners = winners
        self.substitutes = substitutes
        
    }
}


class HistoryManager: ObservableObject {
    static let `default` = HistoryManager()
    
    @Published var historyList: [HistoryItem] = []
    
    var db: Connection?
    
    init() {
        prepareDB()
        loadHistory()
        
    }
    
    
    
}

extension HistoryManager {
    fileprivate func dbPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        debugPrint("dbPath: \(documentPath)/GiveawayHistory.sqlite")
        return "\(documentPath)/GiveawayHistory.sqlite"
    }
    
    fileprivate func createTables() {
        createHistoryTable()
    }
//    (postUrl: String, prize: String, winners: [String: String], substitutes: [String: String])
    /// 创建收藏列表 TABLE
    fileprivate func createHistoryTable() {
        let table = Table("PrizeHistory")
        let id = Expression<Int64>("id")
        let postUrl = Expression<String?>("postUrl")
        let prize = Expression<String?>("prize")
        let winnersDictStr = Expression<String?>("winnersDictStr")
        let substitutesDictStr = Expression<String?>("substitutesDictStr")
        let updateDate = Expression<Int64>("update_date")
        
        do {
            try db?.run(table.create { t in
                t.column(id, primaryKey: true)
                t.column(postUrl)
                t.column(prize)
                t.column(winnersDictStr)
                t.column(substitutesDictStr)
                t.column(updateDate)
            })
        } catch {
            debugPrint("dberror: create table failed. - \("History")")
        }
    }
}

extension HistoryManager {
    
    func prepareDB() {
        do {
            db = try Connection(dbPath())
            createTables()
        } catch {
            debugPrint("prepare database error: \(error)")
        }
        
    }
    
    func loadHistory() {
        
        do {
            if let results = try db?.prepare("select * from PrizeHistory ORDER BY update_date DESC;") {
                for row in results {
                    let id = row[0] as? Int64 ?? 0
                    let postUrl = row[1] as? String ?? ""
                    let prize = row[2] as? String ?? ""
                    let winnersDictStr = row[3] as? String ?? ""
                    let winnerDict = winnersDictStr.toDictionary() as? [String: [[String: String]]] ?? ["":[["": ""]]]
                    var winnerItemList: [HistoryWinnerItem] = []
                    if let winnerDictList = winnerDict["list"] {
                        for dict in winnerDictList {
                            let item = HistoryWinnerItem.init(dict: dict)
                            winnerItemList.append(item)
                        }
                    }
                    
                    
                    let substitutesDictStr = row[4] as? String ?? ""
                    let substitutesDict = substitutesDictStr.toDictionary() as? [String: [[String: String]]] ?? ["":[["": ""]]]
                    var substitutesItemList: [HistoryWinnerItem] = []
                    if let substitutesDictList = substitutesDict["list"] {
                        for dict in substitutesDictList {
                            let item = HistoryWinnerItem.init(dict: dict)
                            substitutesItemList.append(item)
                        }
                    }
                    
                    let historyItem = HistoryItem(id: Int(id), postUrl: postUrl, prize: prize, winners: winnerItemList, substitutes: substitutesItemList)
                    
                    historyList.append(historyItem)
                }
            }
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
    
    func addHistory(postUrl: String, prize: String, winners: [[String: String]], substitutes: [[String: String]]) {
        
        var id: Int = 0
        if let firstItem = historyList.first {
            id = firstItem.id + 1
        }
        
        let winnersDict: [String:[[String: String]]] = ["list": winners]
        let winnersString = winnersDict.toJsonString()
        let substitutesDict: [String:[[String: String]]] = ["list": winners]
        let substitutesString = substitutesDict.toJsonString()
        let date = Int64(Date().timeIntervalSince1970.int)
        do {
            let stmtForHistory = try db?.prepare("INSERT OR REPLACE INTO PrizeHistory (id, postUrl, prize, winnersDictStr, substitutesDictStr, update_date) VALUES (?,?,?,?,?,?)")
            try stmtForHistory?.run([id, postUrl, prize, winnersString, substitutesString, date])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.loadHistory()
            }
        } catch {
            
        }
        
    }
     
    func deleteHistoryListData(_ historyItemId: Int64) {
       let table = Table("PrizeHistory")
       let db_historyId = Expression<Int64>("id")
       let alice = table.filter(db_historyId == historyItemId)
       do {
           try db?.run(alice.delete())
       } catch {
           debugPrint("dberror: delete table failed. - \("History"):\(historyItemId)")
       }
   }
    
}

