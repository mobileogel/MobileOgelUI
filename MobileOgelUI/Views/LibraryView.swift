//
//  LibraryView.swift
//  MobileOgelUI
//
//  Contributors: Harsimran Kanwar, Shuvaethy Neill, and Guy Morgenshtern
//

import SwiftUI

enum FilterCategory: String, CaseIterable {
    case Perfect, Similar, All
}

struct LegoSet: Identifiable, Hashable, Equatable {
    let id = UUID()
    var setId: Int
    var setName: String
    var pieceCount: Int
    var piecesMissing: [LegoPiece]?
    
    //these two functions are apparently needed to fix "not conforming to Type Hashable and Equatable error, because of "missingPieces" var
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: LegoSet, rhs: LegoSet) -> Bool {
        return lhs.id == rhs.id
    }
}

//this is data that should come from an endpoint (not necessarily formated to be an object)
var allSampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2)]), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1)])]

var fuzzySampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 4), LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 2)]), LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328, piecesMissing: [LegoPiece(imageName: "2x4_black", pieceName: "Brick 2x4", quantity: 1)])]

var perfectSampleData: [LegoSet] = [LegoSet(setId: 40570, setName: "Halloween Cat & Mouse", pieceCount: 328)]


struct LibraryView: View {
    @State private var selectedItem: FilterCategory = .Perfect // Default
    
    var body: some View {
        NavigationStack{
            VStack {
                HeaderView(title: "Library")
                
                VStack {
                    HStack() {
                        ForEach(FilterCategory.allCases, id: \.self) { item in
                            FilterItem(filterCategory: item, selectedFilter: $selectedItem)
                        }
                        
                    }
                    switch selectedItem {
                    case .All:
                        //TODO: rely on data from endpoint
                        SetsListView(setList: allSampleData, selectedFilter: $selectedItem)
                    case .Similar:
                        //TODO: rely on data from endpoint
                        SetsListView(setList: fuzzySampleData, selectedFilter: $selectedItem)
                    default:
                        //TODO: rely on data from endpoint
                        SetsListView(setList: perfectSampleData, selectedFilter: $selectedItem)
                    }
                    
                }
                
                Spacer()
            }
        }
        
        
    }
}

//TODO: very rough, need to refactor (also ideally we would would want to use VM for all data)
struct FilterItem: View {
    let filterCategory: FilterCategory
    @Binding var selectedFilter: FilterCategory
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(selectedFilter == filterCategory ? Color(red: 0.859, green: 0.929, blue: 0.702) : Color(red: 0.902, green: 0.906, blue: 0.91))
                .frame(width: 80, height: 50)
            
            Text(filterCategory.rawValue)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
        }
        .onTapGesture {
            selectedFilter = filterCategory
        }
    }
}

struct SetsListView: View {
    var setList: [LegoSet]
    @Binding var selectedFilter: FilterCategory
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                Section {
                    
                    ForEach(setList, id: \.self) { sample in
                        LegoSetView(set: sample).alignmentGuide(.top, computeValue: { _ in 0 })
                    }
                }
            }
            .padding(6)
        }
    }
}

struct LegoSetView: View {
    var set: LegoSet
    var body: some View {
        HStack(alignment: .top) {
            Image("\(set.setId)_thumbnail")
                .resizable()
                .frame(width: 80, height:80)

            
            VStack(alignment: .leading) {
                Text(set.setName)
                    .font(.headline)
                Text("\(set.pieceCount) Pieces")
                Link("Instructions", destination: URL(string: "https://www.lego.com/en-ca/service/buildinginstructions/\(set.setId)")!)
                if set.piecesMissing != nil {
                    MissingPiecesView(visible: false, missingPieces: set.piecesMissing!)
                }
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(Color(red: 0.89, green: 0.937, blue: 1.0))
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

struct MissingPiecesView: View {
    @State var visible: Bool
    var missingPieces: [LegoPiece]
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
            HStack {
                Button("Missing Pieces") {
                    visible.toggle()
                }.frame(alignment: .leading)
                Spacer()
            }
            if visible {
                ForEach(missingPieces, id: \.self) { piece in
                    PieceTileView(piece: piece).scaleEffect(1)
                }
            }
        }
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
