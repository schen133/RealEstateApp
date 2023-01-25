//
//  ContentView.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/5/22.
//

import CoreAudio
import simd
import CoreData
import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Apartment.date, ascending: false)],
        animation: .default)
    private var apartData: FetchedResults<Apartment>
    @State private var addImagePresenting = false


    var body: some View {
        NavigationView {
            List {
                ForEach(apartData) { apartment in
                    NavigationLink {
                        ApartmentView(apartmentData: apartment)
                    } label: {
                        HStack {
                            Image(imageData: apartment.image, placeholder: "rochester")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48, alignment: .center)
                            VStack(alignment: .leading) {
                                Text(apartment.title ?? "")
                                    .font(.body)
                                Text("$\(apartment.rent)/month")
                                    .font(.caption)
                                    .lineLimit(2)
                                Text("\(apartment.sqft) Sqft")
                                    .font(.caption)
                                    .lineLimit(2)
                            }
                        }
                        .padding(4)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addImagePresenting.toggle()
                    }, label: {
                        Label("Add ImageData", systemImage: "plus")
                    })
                }
            }
            .sheet(isPresented: $addImagePresenting) {
                AddApartmentView()
                
            }
            .navigationTitle("NewDigs")
            .foregroundColor(.blue)
        }//end of navigationView
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { apartData[$0]
            }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
   }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
      
    }
}
