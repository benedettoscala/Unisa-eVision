//
//  BuildingView.swift
//  UniSa eVision prototipo
//
//  Created by Simona Grieco on 17/02/23.
//

import SwiftUI

struct IDString: Identifiable{
    let id = UUID()
    let value: String
}

struct InformationBuilding: Identifiable {
    let id = UUID()
    let iname: String
    let idescrizione: String?
    let list: [IDString]?
    
    init(iname: String, idescrizione: String? = nil, list: [IDString]? = nil) {
        self.iname = iname
        self.idescrizione = idescrizione
        self.list = list
    }
}


let information : [InformationBuilding] = [
    InformationBuilding(iname: "Dipartimento", idescrizione: "..."),
    InformationBuilding(iname: "Bar", idescrizione: "..."),
    InformationBuilding(iname: "Cartolibreria", idescrizione: "..."),
    InformationBuilding(iname: "Aule studio",
                        list: [IDString(value: "aula studio 1"),
                               IDString(value: "aula studio 2"),
                               IDString(value: "aula studio 3"),
                              ])
]
struct BuildingView: View {
    var body: some View {
        VStack {
            Text("Unisa eVision").font(.headline)
            
            List(information){ information in
                Section(header: Text(information.iname)){
                    if(information.idescrizione != nil){
                        Text(information.idescrizione!)
                    }
                    
                    if (information.list != nil) {
                        ForEach(information.list!) { s in
                            Text(s.value)
                        }
                    }
                    
                }
            }.listStyle(InsetGroupedListStyle())
        }
    }
}



struct BuildingView_Previews: PreviewProvider {
    static var previews: some View {
        BuildingView()
    }
}
