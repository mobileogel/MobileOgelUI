//
//  getInstructions.swift
//  MobileOgelUI
//
//  Created by Harsimran Kanwar on 2024-01-20.
//
import MongoKitten

//rn this function connects to mongo and returns all sets in the db
func connectDbAndFetchAll() async -> [Document]?{
    do {
        //using the test db bc there's an item in it but otherwise our official db is named 'db'
        let connectionString = "mongodb+srv://aarongabor4:test1234@aaroncluster.htzvngg.mongodb.net/test"
        
        // Asynchronous call to connect to MongoDB
        let db = try await MongoDatabase.connect(to: connectionString)
        
        
        // Access the "instructions" collection
        let collection = db["instructions"]
        print("Connected to MongoDB")

        // Fetch the count of documents asynchronously
        let count = try await collection.count()
        print("Collection Size: \(count)")
        
        let sets = try await collection.find().drain()
        return sets
        
    } catch {
        print("ERROR CONNECTING TO SERVER: \(error)")
        return []
    }
}

/*import MongoSwiftSync

defer {
    cleanupMongoSwift()
}


//Global variable to allow the connection to be closed elsewhere
private let client: MongoClient?

//This method is used to connect to the server
private func connectToServer() -> Collection?
{
    do {
        let uri = "mongodb+srv://aarongabor4:<test1234>@aaroncluster.htzvngg.mongodb.net/"
        client = try MongoClient(uri)
        let database = client.db("db")
        let collection = database.collection("instructions")
        return collection
    } catch error {
        print("ERROR CONNECTING TO SERVER: \(error)")
        return nil
    }
    
}

//This method will retrieve the instructions stored on the server and 
//returns the instructions to be displayed to the user for the pieces the user has
public func getInstructionsHave(queryType: Int) -> [LegoSet]
{
    //Gets the scanned pieces from  the local database getPieces method from swiftLocalDB.swift
    var pieces = getPieces()

    var query: Document = [:]

    //Creating the query for the server side database form the scanned pieces
    //If queryType is 0 then the query will include dimension, colour, quantity
    if queryType == 0
    {
        query["pieces"] = [
            "$elemMatch": [
                "$and": pieces.map {piece in
                    [
                        "dimension": piece["pieceName"] as! String,
                        "colour": piece["colour"] as! String,
                        "quantity": ["$lte": piece["quantity"] as! Int]
                    ]
                }
            ]
        ]
    }
    //If queryType is 1 then the query will include dimension, quantity
    else if queryType == 1
    {
        query["pieces"] = [
            "$elemMatch": [
                "$and": pieces.map {piece in
                    [
                        "dimension": piece["pieceName"] as! String,
                        "quantity": ["$lte": piece["quantity"] as! Int]
                    ]
                }
            ]
        ]
    }

    //Used to exclude pieces array from the query
    var projection: Document = [
        "_id": 0,
        "pieces": 0
    ]

    //Runs method to connect to server
    let collection = connectToServer()
    //Runs the query on the server's database
    let results = try connection.find(query, options: FindOptions(projecrion: projection))
    //Ends the connection to the server
    client.syncClose()

    //Creates an empty return value
    var output: [LegoSet] = []
    //Runs through all documents that were returned from the query
    for result in results 
    {
        //Decodes the imformation stored in the document from the server
        //and assigns them there correct variable type
        let setId = result["setId"] as? Int
        let setName = result["setName"] as? String
        let pieceCount = result["pieceCount"] as? Int
        let url = result["url"] as? String
        
        //Creates the LegoSet structure will the documents values and
        //stores them in the return value
        output.append(LegoSet(setId: setId, setName: setName, pieceCount: pieceCount, piecesMissing: nil, url: url))
    }

    return output
}
 */
