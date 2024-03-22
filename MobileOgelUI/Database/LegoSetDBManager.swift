//
//  getInstructions.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2024-01-20.
//
import MongoKitten
import Foundation
import SQLite


//rn this function connects to mongo and returns all sets in the db
class LegoSetDBManager{
    
    static let initializer = LegoSetDBManager()
    
    private let db: Connection?
    
    private let setsTable = Table("sets")
    private let id = Expression<Int>("id")
    private let setId = Expression<Int>("setId")
    private let setName = Expression<String>("setName")
    private let setUrl = Expression<String>("setUrl")
    private let pieceCount = Expression<Int>("pieceCount")
    private let missingPieces = Expression<String>("missingPieces")
    private let setMatchType = Expression<String>("setMatchType")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/db.sqlite")
            
            //createLocalTable()
        } catch {
            db = nil
            print("Unable to open database - error: \(error)")
        }
    }
    
    func createLocalTable() {
        guard let db = db else { return }
        do {
            try db.run(setsTable.drop(ifExists: true))
            
            try db.run(setsTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(setId)
                table.column(setName)
                table.column(setUrl)
                table.column(pieceCount, defaultValue: 0)
                table.column(missingPieces)
                table.column(setMatchType)
                print("create set table -successful")
                
            })
        } catch {
            print("Unable to create table - error: \(error)")
        }
    }
    
    func getLocalTableCount() -> Int{
        var setCount = 0
        guard let db = db else { return 0}
        do {
            // Check if the table is empty
            setCount = try db.scalar(setsTable.count)
        } catch {
            print("Unable to find table - error: \(error)")
        }
        return setCount
    }
    
    func dropSetsTable() {
        guard let db = db else { return }
        do {
            try db.run(setsTable.drop(ifExists: true))
            print("dropped sets table")
        } catch {
            print("Unable to drop table")
        }
    }
    
    func addSetToLocal(matchedSet: LegoSet, matchType: String) {
        guard let db = db else { return }
        do {
            //convert missing pieces to JSON for storage
            let missingPiecesData = try JSONEncoder().encode(matchedSet.piecesMissing)
            let missingPiecesString = String(data: missingPiecesData, encoding: .utf8)!
            
            //set the values
            let insertSet = setsTable.insert(
                self.setId <- matchedSet.setId,
                self.setName <- matchedSet.setName,
                self.setUrl <- matchedSet.setUrl,
                self.pieceCount <- matchedSet.pieceCount,
                self.missingPieces <- missingPiecesString,
                self.setMatchType <- matchType
                )

            //run the query
                try db.run(insertSet)
        } catch {
            print("Error adding piece: \(error)")
        }
    }
    
    func checkSetStoredUnderPerf(setId: Int) -> Bool {
        guard let db = db else { return false }
        do {
            // Check if the set exists in the database
            let setExistsQuery = setsTable.filter(self.setId == setId && self.setMatchType == "Perfect")
            return try db.pluck(setExistsQuery) != nil
        } catch {
            print("Error checking if set exists: \(error)")
            return false
        }
    }
    
    func fetchSetsFromLocal() -> ([LegoSet], [LegoSet]){
        var perfectMatches: [LegoSet] = []
        var fuzzyMatches: [LegoSet] = []
        do {
            guard let db = db else { return ([], []) }

            let query = setsTable
            for setRow in try db.prepare(query) {
                let setId = try setRow.get(self.setId)
                let setName = try setRow.get(self.setName)
                let setUrl = try setRow.get(self.setUrl)
                let setPieceCount = try setRow.get(self.pieceCount)
                let missingPieces = try setRow.get(self.missingPieces)
                let setMatchType = try setRow.get(self.setMatchType)
                
                
                //decode the pieces:
                let missingPiecesData = missingPieces.data(using: .utf8)!
                let missingPiecesArray = try JSONDecoder().decode([LegoPiece].self, from: missingPiecesData)
                
                let set = LegoSet(
                    setId: setId,
                    setName: setName,
                    pieceCount: setPieceCount,
                    piecesMissing: missingPiecesArray,
                    setUrl: setUrl,
                    matchType: setMatchType
                    
                    )

                if setMatchType == "Perfect" {
                    perfectMatches.append(set)
                } else if setMatchType == "Fuzzy" {
                    fuzzyMatches.append(set)
                }
            }
        } catch {
            print("Error retrieving pieces: \(error)")
        }

        return (perfectMatches, fuzzyMatches)
    }
    
    
    
    
    //mongo stuff
    func connectDbAndFetchAll() async -> [[String:Any]]?{
        do {
            //currently we have 10 sets
            let connectionString = "mongodb+srv://aarongabor4:test1234@aaroncluster.htzvngg.mongodb.net/db?dnsServer=1.1.1.1"
            
            // Asynchronous call to connect to MongoDB
            let db = try await MongoDatabase.connect(to: connectionString)
            
            
            // Access the "instructions" collection
            let collection = db["instructions"]
            print("Connected to MongoDB")
            
            // Fetch the count of documents asynchronously
            let count = try await collection.count()
            print("Collection Size: \(count)")
            
            let sets = try await collection.find().drain()
            
            var formattedSets: [[String: Any]] = []
            
            for set in sets {
                // Convert Document to [String: Any]
                var formattedSet: [String: Any] = [:]
                for (key, value) in set {
                    formattedSet[key] = value
                }
                formattedSets.append(formattedSet)
            }
            
            return formattedSets
            //return sets
            
        } catch {
            print("ERROR CONNECTING TO SERVER: \(error)")
            return []
        }
    }
    
    //helper method to convert Documents to LegoSet format
    func convertToLegoSet(from dict: [String: Any], missingPieces: [LegoPiece], type: String) -> LegoSet? {
        guard let setId = dict["setID"] as? Int32,
              let setName = dict["setName"] as? String,
              let pieceCount = dict["pieceCount"] as? Int32,
              let setUrl = dict["setUrl"] as? String else {
            print("Failed to extract required values from dictionary: \(dict)")
            return nil
        }
        
        return LegoSet(setId: Int(setId),
                       setName: setName,
                       pieceCount: Int(pieceCount),
                       piecesMissing: missingPieces, // Assuming this will be set later
                       setUrl: setUrl,
                       matchType: type)
    }
    
    
    
    func findPerfectMatches(allSets: [[String:Any]], myPieces: [LegoPiece]) {
        //let allSets = await connectDbAndFetchAll()
        var matchingSets: [LegoSet] = []
        print("in perf matches")
        
        for set in allSets {
            guard let piecesDocument = set["pieces"] as? Document else {
                print("Invalid or missing pieces data")
                continue
            }
            
            var setPieces: [[String:Any]] = []
            for (_, piece) in piecesDocument {
                var pieceDict: [String: Any] = [:]
                if let piece = piece as? Document {
                    for (key, value) in piece {
                        pieceDict[key] = value
                    }
                }
                setPieces.append(pieceDict)
            }
            //print(setPieces)
            
            var allPiecesMatch = true
            
            for setPiece in setPieces {
                let quantity = Int((setPiece["quantity"] as? Int32)!)
                
                let perfMatchCriteria = myPieces.contains { $0.pieceName == ClassToNameMap.getMappedValue(forKey: ((setPiece["dimension"] as? String)!)) && $0.officialColour.rawValue == setPiece["colour"] as! String && $0.quantity >= quantity}
                
                if perfMatchCriteria{
                    continue
                }else{
                    //print("set piece not present moving onto next set")
                    allPiecesMatch = false
                    break
                }
            }
            
            if allPiecesMatch {
                //print("FOUND ONE")
                let convertedSet = convertToLegoSet(from: set, missingPieces: [], type: "Perfect")
                addSetToLocal(matchedSet: convertedSet!, matchType: "Perfect")
                matchingSets.append(convertedSet!)
            }
            
        }
        
    }
    
    
    func findFuzzyMatches(allSets: [[String:Any]], myPieces: [LegoPiece]){
        print("in fuzzy")
        
        
        for set in allSets {
                guard let piecesDocument = set["pieces"] as? Document else {
                    print("Invalid or missing pieces data")
                    continue
                }
                
                var setPieces: [[String:Any]] = []
                for (_, piece) in piecesDocument {
                    var pieceDict: [String: Any] = [:]
                    if let piece = piece as? Document {
                        for (key, value) in piece {
                            pieceDict[key] = value
                        }
                    }
                    setPieces.append(pieceDict)
                }
                
            var missingPieces: [[String:Any]] = []
                var myPiecesDict: [String: Int] = [:]
            
                //add up quatities of same pieces + create dictionary of piece name to quantity
                for piece in myPieces {
                    if let existingQuantity = myPiecesDict[piece.pieceName] {
                        myPiecesDict[piece.pieceName] = existingQuantity + piece.quantity
                    } else {
                        myPiecesDict[piece.pieceName] = piece.quantity
                    }
                }
                
            
                for setPiece in setPieces {
                    let pieceName = ClassToNameMap.getMappedValue(forKey: (setPiece["dimension"] as? String)!)
                    let quantity = Int((setPiece["quantity"] as? Int32)!)
                    
                    
                    let fuzzyMatchCriteria = myPiecesDict.contains { $0.key == ClassToNameMap.getMappedValue(forKey: ((setPiece["dimension"] as? String)!)) && myPiecesDict[$0.key]! >= quantity }
                    
                    if !fuzzyMatchCriteria {
                        missingPieces.append(setPiece)
                    }
                }
                
                if missingPieces.count < 4 {
                    let legoPieces = missingPieces.map { dict in
                        let imageName = (dict["dimension"] as? String)! + "_" + String(describing: LegoColour(rawValue: dict["colour"] as! String)!)
                        
                        return LegoPiece(imageName: Util.getImageNameOrPlaceHolder(withX: imageName),
                                         pieceName: ClassToNameMap.getMappedValue(forKey: ((dict["dimension"] as? String)!)),
                                         quantity: Int((dict["quantity"] as? Int32)!),
                                         officialColour: LegoColour(rawValue: dict["colour"] as! String) ?? .unknown)
                    }
                    
                    let convertedSet = convertToLegoSet(from: set, missingPieces: legoPieces,type: "Fuzzy")
                    // Check if the set already exists as a perfect match
                    if !checkSetStoredUnderPerf(setId: convertedSet!.setId){
                        addSetToLocal(matchedSet: convertedSet!, matchType: "Fuzzy")
                        //print("Missing pieces: \(missingPieces)")
                    }
                }
            }
    }
}



