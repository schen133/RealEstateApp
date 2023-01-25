//
//  ApartmentView.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/5/22.
//

import SwiftUI
import MapKit


struct ApartmentView: View {
    @State private var isEditing: Bool = false
    var apartmentData: Apartment
//    @EnvironmentObject var locationVM: LocationVM

    var body: some View {
        var stringPrice = currencyFormatter.string(for: apartmentData.rent)!
        //address, date, image, title,
        //notes, phone, rent and sqft
        //mapView
        ZStack(alignment: .center) {
            Color.white
                .edgesIgnoringSafeArea([.all])
            
            VStack(alignment: .center, spacing: 50) {
                
                VStack(alignment: .center, spacing: 5){
                    NavigationLink(destination:
                                    ImageView(apartmentDataForZoom: apartmentData).onAppear {
                    }) {
                        Image(imageData: apartmentData.image, placeholder: "rochester")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
//                    Image(imageData: apartmentData.image, placeholder: "rochester")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .padding()
                Text("Price: \(stringPrice ?? "") per month")
                    .foregroundColor(.black)
                Text("Sqft: \(apartmentData.sqft)")
                    .foregroundColor(.black)
                NavigationLink {
                    MapView(coord: CLLocationCoordinate2D(latitude: apartmentData.latitude, longitude: apartmentData.longitude))                } label: {
                    Image("loca")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                }
                }
                .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Posted at \(apartmentData.date!, formatter: itemFormatter)")
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("Address: ")
                            .foregroundColor(.black)
                        Text(apartmentData.address ?? "")
                            .foregroundColor(.black)
                    }
                    VStack{
                        Text("Notes from landlord: ")
                            .foregroundColor(.black)
                        Text(apartmentData.notes ?? "")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        HStack{
                            Text("Contact:")
                                .foregroundColor(.black)
                            Text(apartmentData.phone ?? "")
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        Text("Latitude:")
                        Text(String(apartmentData.latitude ?? 0))
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("Longitude:")
                        Text(String(apartmentData.longitude ?? 0))
                            .foregroundColor(.green)
                    }
                    Text(apartmentData.houseyears ?? "")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                }
                .background(border)
            }
            .foregroundColor(.white)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
            .padding()
            
            Spacer()
            Spacer()
        }
        .navigationBarTitle(apartmentData.title ?? "", displayMode: .inline)
        .padding()
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius:10)
//          .frame(width: 2, height: 2)
          .strokeBorder(
            LinearGradient(
              gradient: .init(
                colors: [
                    Color(.black)
                ]
              ),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: isEditing ? 4 : 2
          )
          .frame(width: 330, height: 310)
      }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
    
}()


