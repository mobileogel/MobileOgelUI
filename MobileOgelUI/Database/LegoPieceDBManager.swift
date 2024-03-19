import Foundation
//import SQLite3
import SQLite

class LegoPieceDBManager {
    static let shared = LegoPieceDBManager()
    private let db: Connection?
    private let piecesTable = Table("pieces")
    private let id = Expression<Int>("id")
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
                table.column(id, primaryKey: .autoincrement)
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
                let insertPiece = piecesTable.insert(
                    self.imageName <- piece.imageName,
                    self.pieceName <- piece.pieceName,
                    self.colour <- piece.officialColour.rawValue,
                    self.quantity <- piece.quantity)
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
                
                let piece = LegoPiece(
                    imageName: imageName,
                    pieceName: pieceName,
                    quantity: quantity,
                    officialColour: LegoColour(rawValue: colour) ?? .black
                )
                allPieces.append(piece)
            }
        } catch {
            print("Error retrieving pieces: \(error)")
        }
        return allPieces
    }
    
    func deleteAllPieces() {
        guard let db = db else { return }
        let deleteAll = piecesTable.delete()
        do {
            try db.run(deleteAll)
        } catch {
            print("Error deleting all pieces: \(error)")
        }
    }
}

