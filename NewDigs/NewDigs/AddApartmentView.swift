//
//  AddApartmentView.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/5/22.
//
import SwiftUI
import Foundation
import MapKit

struct AddApartmentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    //Feature: How long has the house been built
    private var houseyears = ["<5ys", "<10ys",
    "<20ys", "20ys+"]
    @State private var title = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var address = ""
    @State private var phone = ""
    @State private var notes = ""
    @State private var rent = 0
    @State private var sqft = 0
    @State private var uiImage: UIImage?
    @State private var imagePickerPresenting = false
    @State private var isEditing: Bool = false
    @State private var occasionIndex = 0
    @StateObject var locationVM = LocationVM()

    var body: some View {
        VStack {
            VStack {
                ZStack {
                    
                    VStack {
                        Image(uiImage: uiImage ?? UIImage(imageLiteralResourceName: "rochester"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(9)
                            .clipShape(Rectangle())
//                            .padding()
                            .onTapGesture {
                                imagePickerPresenting.toggle()
                            }
                        Spacer()
                        VStack {
                            Section(header: Text("Details").font(.headline).foregroundColor(.black)){
                            TextField("Title", text: $title)
                                .background(.white)
                                .foregroundColor(.black)
                                .background(border)
                            TextField("Address", text: $address)
                                .background(.white)
                                .foregroundColor(.black)
                                .background(border)
                            TextField("Phone", text: $phone)
                                .background(.white)
                                .foregroundColor(.black)
                                .background(border)
                            
                                TextField("Rent", value: $rent, formatter: NumberFormatter())
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .background(border)
                                TextField("Sqft", value: $sqft, formatter: NumberFormatter())
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .background(border)
                                
//                            TextField("Longitude", double: $longitude)
//                                .background(.white)
//                                .foregroundColor(.black)
//                                .padding()
//                                .background(border)
//                            TextField("Latitude", text: $latitude)
//                                .background(.white)
//                                .foregroundColor(.black)
//                                .padding()
//                                .background(border)
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            Section(header: Text("House quality").font(.headline).foregroundColor(.black)){
                            TextField("Notes", text: $notes)
                                .background(.white)
                                .foregroundColor(.black)
                                .background(border)
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Section(header: Text("How long house built for").font(.headline).foregroundColor(.white)){
                                Picker("Built", selection: $occasionIndex) {
                                    ForEach(0..<houseyears.count){
                                        Text(self.houseyears[$0])
                                    }
                                }
                            .pickerStyle(.segmented)
                            .background(.white)
                            }
                        }
                    }
                    .padding()
                }
            }
//            Button(action: {
//                locationVM.toggleService()
//            }, label: {
//                Text("Get current location?")
//            })
////            .disabled(locationVM.enabled)
//            .foregroundColor(.black)
            Button(action: {
                locationVM.toggleService()
                addApartment()
            }, label: {
                Text("Save")
            })
            .disabled(title.isEmpty)
            .disabled(locationVM.enabled)

            .font(.largeTitle)
            
            Spacer()
        }
        .sheet(isPresented: $imagePickerPresenting) {
            PhotoPicker(image: $uiImage)
        }
//        .actionSheet(isPresented: $locationVM.deniedAlertPresenting) {
//            ActionSheet(
//                title: Text("This app was denied permission. Would you like to update your settings?"),
//                buttons: [
//                    .cancel(Text("OK")) {
//                        if let url = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.open(url)
//                        }
//                    },
//                    .default(Text("No")),
//                ])
//
//        }
//        .alert("Access to location services is blocked by parental controls.", isPresented: $locationVM.restrictedAlertPresenting) {
//            Button("OK", role: .cancel) { }
//        }
        .padding()
    }
    
    //generate latitude & longitude
    private func addApartment() {
        withAnimation {
            let ApartData = Apartment(context: viewContext)
            ApartData.address = address
            ApartData.latitude = locationVM.location?.coordinate.latitude ?? 0
            ApartData.longitude = locationVM.location?.coordinate.longitude ?? 0
            ApartData.title = title
            ApartData.notes = notes
            ApartData.phone = phone
            ApartData.rent = Int16(rent)
            ApartData.sqft = Int16(sqft)
            ApartData.date = Date()
            ApartData.id = UUID()
            
            if let data = uiImage?.jpegData(compressionQuality: 0.8) {
                ApartData.image = data
            }
            do {
                try viewContext.save()
                dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius:10)
//          .frame(width: 2, height: 2)
          .strokeBorder(
            LinearGradient(
              gradient: .init(
                colors: [
                    Color(.yellow)
                ]
              ),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: isEditing ? 6 : 3
          )
          .frame(width: 333, height: 40.8)

      }
}

//struct AddImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddApartmentView()
//
//    }
//}
