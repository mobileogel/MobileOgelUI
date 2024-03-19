//
//  getInstructions.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2024-01-20.
//
import MongoKitten


//rn this function connects to mongo and returns all sets in the db
//func connectDbAndFetchAll() async -> [Document]?{
func connectDbAndFetchAll() async -> [[String:Any]]?{
    do {
        //currently we have 10 sets
        let connectionString = "mongodb+srv://aarongabor4:test1234@aaroncluster.htzvngg.mongodb.net/db"
        
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
func convertToLegoSet(from dict: [String: Any]) -> LegoSet? {
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
                   piecesMissing: [], // Assuming this will be set later
                   setUrl: setUrl)
}

func findPerfectMatches(myPieces: [LegoPiece]) async -> [LegoSet]? {
    let allSets = await connectDbAndFetchAll()
    var matchingSets: [LegoSet] = []
    print("in perf matches")
    
    if let allSets = allSets {
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
                    print("set piece not present moving onto next set")
                    allPiecesMatch = false
                    break
                }
                                                                                                       
                
                
            }

            if allPiecesMatch {
                print("FOUND ONE")
                let convertedSet = convertToLegoSet(from: set)
                matchingSets.append(convertedSet!)
            }
            
        }
    }
    print("matching")
    print(matchingSets)
    
    return matchingSets.isEmpty ? nil : matchingSets
    
    
}

//TODO: fuzzy matches

