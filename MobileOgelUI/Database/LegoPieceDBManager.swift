import Foundation
//import SQLite3
import SQLite

class LegoPieceDBManager {
    static let shared = LegoPieceDBManager()
    private let db: Connection?
    private let piecesTable = Table("pieces")
    private let id = Expression<String>("id")
    private let imageName = Expression<String>("imageName")
    private let pieceName = Expression<String>("pieceName")
    private let colour = Expression<String>("colour")
    private let quantity = Expression<Int>("quantity")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/db.sqlite")
            
            createTable()
        } catch {
            db = nil
            print("Unable to open database - error: \(error)")
        }
    }
    
    private func createTable() {
        guard let db = db else { return }
        do {
            try db.run(piecesTable.create { table in
                table.column(id, primaryKey: true)
                table.column(imageName)
                table.column(pieceName)
                table.column(colour)
                table.column(quantity, defaultValue: 0)
            })
        } catch {
            print("Unable to create table - error: \(error)")
        }
    }
    
    func addPiece(piece: LegoPiece) {
        guard let db = db else { return }
        let existingPiece = piecesTable.filter(self.pieceName == piece.pieceName)
        do {
            // check if piece exists to update quantity instead
            if try db.pluck(existingPiece) != nil {
                updatePiece(name: piece.pieceName, newQuantity: piece.quantity)
            } else {
                // piece doesn't exist, add new entry
                let insertPiece = piecesTable.insert(self.imageName <- piece.imageName, self.pieceName <- piece.pieceName, self.colour <- piece.colour, self.quantity <- piece.quantity)
                try db.run(insertPiece)
            }
        } catch {
            print("Error adding piece: \(error)")
        }
    }
    
    func updatePiece(name: String, newQuantity: Int) {
        guard let db = db else { return }
        let piece = piecesTable.filter(self.pieceName == name)
        let updatePiece = piece.update(self.quantity <- newQuantity)
        do {
            try db.run(updatePiece)
        } catch {
            print("Error updating piece: \(error)")
        }
    }
    
    // this would be used if we have a delete button next to the piece on the edit pieces page?
    func deletePiece(name: String) {
        guard let db = db else { return }
        let piece = piecesTable.filter(self.pieceName == name)
        let deletePiece = piece.delete()
        do {
            try db.run(deletePiece)
        } catch {
            print("Error deleting piece: \(error)")
        }
    }
    
    func getAllPieces() -> [LegoPiece] {
        var allPieces: [LegoPiece] = []
        do {
            guard let db = db else { return [] }
            let query = piecesTable
            for pieceRow in try db.prepare(query) {
                let imageName = try pieceRow.get(self.imageName)
                let pieceName = try pieceRow.get(self.pieceName)
                let colour = try pieceRow.get(self.colour)
                let quantity = try pieceRow.get(self.quantity)
                
                let piece = LegoPiece(imageName: imageName, pieceName: pieceName, colour: colour, quantity: quantity)
                allPieces.append(piece)
            }
        } catch {
            print("Error retrieving pieces: \(error)")
        }
        return allPieces
    }
}

/*
 func connectDatabase() -> OpaquePointer?
 {
 var db: OpaquePointer
 let dbPath = URL(fileURLWithPath : "")
 if sqlite3_open(dbPath.path, &db) == SQLITE_OK
 {
 print("Connection Made")
 return db
 }
 else
 {
 print("ERROR opening database")
 return nil
 }
 }
 
 func increaseQuanityByOne(type: String, colour: String)
 {
 db = connectDatabase()
 let sql = "UPDATE pieces SET quantity = Quantity + 1 WHERE type =" + type + " AND colour = " + colour + ";"
 
 if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print(errmsg)
 }
 sqlite3_close(db)
 }
 
 func decreaseQuanityByOne(type: String, colour: String)
 {
 let db = connectDatabase()
 let sql = "UPDATE pieces SET quantity = Quantity - 1 WHERE type =" + type + " AND colour = " + colour + ";"
 
 if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print(errmsg)
 }
 sqlite3_close(db)
 }
 
 func createTable()
 {
 let sql = "CREATE TABLE IF NOT EXISTS pieces(ID INTEGER NOT NULL, ImageName varchar(255) NOT NULL, PieceName varchar(255) NOT NULL, Colour varchar(255) NOT NULL, Quantity INTEGER NOT NULL DEFAULT 0,PRIMARY KEY(ID));"
 
 let db = connectDatabase()
 
 if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print(errmsg)
 }
 sqlite3_close(db)
 }
 
 func addNewPiece(piece: LegoPiece, db: OpaquePointer?) {
 let sql = "INSERT INTO pieces (ID, ImageName, PieceName, Colour, Quantity) VALUES ( ?, ?, ?, ?, ?);"
 
 var stmt: OpaquePointer?
 
 if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
 sqlite3_bind_int(stmt, 1, Int32(piece.id))
 sqlite3_bind_text(stmt, 2, (piece.imageName as NSString).utf8String, -1, nil)
 sqlite3_bind_text(stmt, 3, (piece.pieceName as NSString).utf8String, -1, nil)
 sqlite3_bind_text(stmt, 4, (piece.colour as NSString).utf8String, -1, nil)
 sqlite3_bind_text(stmt, 5, (piece.quantity as NSString).utf8String, -1, nil)
 
 if sqlite3_step(stmt) != SQLITE_DONE {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print("Error inserting piece: \(errmsg)")
 }
 sqlite3_finalize(stmt)
 }
 else
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print("Error preparing statement: \(errmsg)")
 }
 }
 
 public func addPieces(pieces: [LegoPiece])
 {
 let db = connectDatabase()
 for piece in pieces
 {
 addNewPiece(piece, db)
 }
 sqlite3_close(db)
 }
 
 public func deleteTable()
 {
 let sql = "DROP TABLE IF EXISTS pieces;"
 let db = connectDatabase()
 
 if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print(errmsg)
 }
 sqlite3_close(db)
 createTable()
 }
 
 public func getPieces() -> [LegoPiece]
 {
 let db = connectDatabase()
 let sql = "SELECT * FROM ID ORDER BY Quantity DESC;"
 var statement: OpaquePointer? = nil
 var pieces: [[String: Any]] = []
 
 if sqlite3_prepare_v2(db, sql, -1, &statement, nill) == SQLITE_OK
 {
 while sqlite3_step(statement) == SQLITE_ROW
 {
 let id = sqlite3_column_int(statement, 0)
 let imageName = String(cString: sqlite3_column_text(statement, 1))
 let pieceName = String(cString: sqlite3_column_text(statement, 2))
 let colour = String(cString: sqlite3_column_text(statement, 3))
 let quantity = sqlite3_column_int(statement, 4)
 
 let piece = LegoPiece(id: id, imageName: imageName, pieceName: pieceName, colour: colour, quantity: quantity)
 
 pieces.append(row)
 }
 }
 else
 {
 let errmsg = String(cString: sqlite3_errmsg(db))
 print(errmsg)
 }
 
 sqlite3_finalize(statement)
 sqlite3_close(db)
 return pieces
 }
 */
