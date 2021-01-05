//
//  Home.swift
//  UI-96
//
//  Created by にゃんにゃん丸 on 2021/01/05.
//

import SwiftUI
import MapKit



struct Home: View {
    @State var isdark = false
    @State var isshow = false
    @StateObject var model = MapViewModel()
    @State var locationmanager = CLLocationManager()
    
    var body: some View {
        ZStack{
            MapView()
                .environmentObject(model)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                VStack(spacing:10){
                    
                    if isshow {
                        
                        HStack{
                            
                            Button(action: {isshow.toggle()}, label: {
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                            })
                            
                            
                            TextField("Search Locations", text: $model.txt)
                                .colorScheme(.light)
                            
                            Button(action: {
                                isshow.toggle()
                                model.txt = ""
                                
                            }, label: {
                                
                                Image(systemName: "xmark")
                            })
                            
                            
                            
                            
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                        
                        
                        
                        
                        
                    }
                    
                    
                    else{
                        
                        Button(action: {isshow.toggle()}, label: {
                            
                            
                            
                            Spacer()
                            
                            
                            
                            
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .padding(5)
                                .background(Color.primary)
                                .clipShape(Circle())
                        })
                        .padding()
                        
                    }
                    
                    Spacer()
                    
                    if !model.places.isEmpty && model.txt != ""{
                        ScrollView{
                            
                            VStack(spacing:10){
                                
                                ForEach(model.places){place in
                                    
                                    Text(place.placemark.name ?? "")
                                        .font(.title)
                                        
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .background(Color.white)
                                        .padding(.leading)
                                        .onTapGesture {
                                            model.selectplace(place: place)
                                        }
                                    
                                    
                                    Divider()
                                    
                                    
                                    
                                }
                                
                            }
                            .padding(.top,10)
                            
                        }
                        .background(Color.white)
                        
                        
                    }
                    VStack{
                        
                        
                        Button(action: model.forcusLocation, label: {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        })
                        Button(action: model.updateMaptipe, label: {
                            Image(systemName: model.maptype == .standard ? "network" : "map")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        })
                        
                        Button(action: {withAnimation{ isdark.toggle()}}, label: {
                            Image(systemName: isdark ? "moon.zzz.fill" : "sun.max.fill")
                                .font(.title2)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        })
                        
                        
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                    .padding()
                    
                    
                }
            }
            
            
        }
        .onAppear(perform: {
            locationmanager.delegate = model
            locationmanager.requestWhenInUseAuthorization()
            
        })
        .alert(isPresented: $model.permissionDenied, content: {
            Alert(title: Text("Permisson Denied"), message: Text("Please Enable Permisson In AppSettings"), dismissButton: .default(Text("Go To Settings"),action: {
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                
            }))
        })
        .onChange(of: model.txt, perform: { value in
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                
                
                if value == model.txt{
                    
                    self.model.searchQuery()
                }
            }
            
            
        })
        
        
        
        
        
        .preferredColorScheme(isdark ? .dark : .light)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
