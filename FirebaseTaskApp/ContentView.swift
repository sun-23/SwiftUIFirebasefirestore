//
//  ContentView.swift
//  FirebaseTaskApp
//
//  Created by sun on 20/11/2562 BE.
//  Copyright © 2562 sun. All rights reserved.
//

import SwiftUI

var width = UIScreen.main.bounds.maxX
var height = UIScreen.main.bounds.maxY

//MARK: MainView
struct ContentView: View {
    @State var showMenu: Bool = false
    @State var isPresentingPostScreen: Bool = false
    
    @ObservedObject var Array = DataStore()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center){
                HStack(alignment: .firstTextBaseline) {
                    Button(action: {
                        self.showMenu.toggle()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.white))
                                .frame(width: 100, height: 80, alignment: .leading)
                                .shadow(radius: 20)
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 45))
                                .foregroundColor(.black)
                        }.offset(y: 25)
                    }).padding(.trailing,30)
                    Text("Task")
                        .font(.system(size: 40, weight: .black, design: .default))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing)
                    Spacer()
                    Button(action: {
                        self.isPresentingPostScreen.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color("Pink"))
                        .shadow(color: Color("Pink"),radius: 20)
                    }.sheet(isPresented: $isPresentingPostScreen , content: {
                        PostView(isPresenting: self.$isPresentingPostScreen)
                    })
                    
                }.padding(40)
                
                //MARK: CardScroll
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack {
                    ForEach(Array.dataArr) { data in
                        GeometryReader { geometry in
                            CardView(Data: data)
                                .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 40 ) / -40), axis: (x: 0, y: 10.0, z: 0))
                        }.frame(width: 300, height: 360)
                      }
                  }.padding(40)
                }.animation(.spring())
                
                Button(action: {
                    print("Reload")
                    self.Array.Reload()
                }) {
                    Text("Reload Data")
                       .foregroundColor(.white)
                    .frame(width: width - 80, height: 50, alignment: .center)
                }.background(Color("Blue"))
                .cornerRadius(30)
                .shadow(color: Color("Blue"),radius: 20)
                  .padding(.top,10)
                
            }.position(x: width / 2 ,y: height / 2.5)
             .blur(radius: self.showMenu ? 10 : 0)

            ManuView(showManu: self.$showMenu)
        }//.edgesIgnoringSafeArea(.all)
    }
}

//MARK: CardView

struct CardView: View {
    
    var Data : DataArray
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 40)
                .fill(LinearGradient(gradient: Gradient(colors: [Color("Pink"), Color("Blue")]), startPoint: .top, endPoint: .bottom))
                .frame(width: 246 , height: 350)
                .shadow(color: Color("LightPink"), radius: 30)
            
            VStack(alignment: .leading){
                Text(Data.Title)
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .black, design: .default))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                    .frame(minWidth: 0,maxWidth: 200, alignment: .leading)
                    .lineLimit(nil)
                Text(Data.posts)
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 0,maxWidth: 200, alignment: .leading)
                    .lineLimit(nil)
                Text("Due Date: \(Data.day)")
                .foregroundColor(.white)
                    .font(.system(size: 30, weight: .regular , design: .default))
                .multilineTextAlignment(.leading)
                .frame(minWidth: 0,maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
            }.padding(30)
        }
    }
}

//MARK: ManuView

struct ManuView: View {
    
    @Binding var showManu : Bool
    
    var body : some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.white))
                .shadow(radius: 30)
                .frame(width: 0.8 * width, height: (height/width) * (0.8 * width))
            
            VStack(alignment: .leading){
                HStack {
                    Text("About")
                        .foregroundColor(.black)
                        .font(.system(size: 40, weight: .black, design: .default))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing,60)
                    Button(action: {
                        self.showManu.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    }).shadow(radius: 5)
                    
                }
                Text("Develop by Sun Studio")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .multilineTextAlignment(.leading)
                Text("Version 0.9")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .multilineTextAlignment(.leading)
            }.padding(30)
        }                        // IPhone 11 Pro Scale * Width and Height OF UIScreen
        .offset(x: self.showManu ? (-160/1668) * width : -width, y: (10/2224) * height)
        .animation(.spring())
    }
}

//MARK: PostView

struct PostView: View {
    
    @Binding var isPresenting: Bool
    @State var Title: String = ""
    @State var posts: String = ""
    @State var day = Date()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.white))
                .frame(width:width, height: (height/width) * width)
            
            VStack(alignment: .leading){
                
                Text("Add Task")
                .foregroundColor(.black)
                .font(.system(size: 40, weight: .black, design: .default))
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                    
                    VStack(alignment: .center){
                        
                        HStack(spacing: 20){
                            Text("Title")
                            TextField("Enter Title",text: $Title)
                        }
                        HStack(spacing: 20){
                            Text("Post")
                            TextField("Enter Posts",text: $posts)
                        }
                        DatePicker(selection: $day,in: Date()..., displayedComponents: .date, label: {Text("")})
                        
                        Button(action: {
                            self.isPresenting = false
                            // add data
                            
                            print("Title \(self.Title)")
                            print("posts \(self.posts)")
                            print("day \(self.day)")
                            
                            PostStore(Title: self.Title, posts: self.posts, day: self.day)
                            
                            self.Title = ""
                            self.posts = ""
                            
                        }, label: {
                            Text("Summit")
                            .foregroundColor(.white)
                            .frame(width: width - 80, height: 50, alignment: .center)
                        }).background(Color("Blue"))
                          .cornerRadius(30)
                            .padding(.top,10)
                        
                        Button(action: {
                            self.isPresenting = false
                            
                            self.Title = ""
                            self.posts = ""
                        }, label: {
                            Text("Cancel")
                            .foregroundColor(.white)
                            .frame(width: width - 80, height: 50, alignment: .center)
                        }).background(Color.red)
                          .cornerRadius(30)
                            .padding(.top,10)
                    }
            }.padding(40)
            .padding(.top,height / 16)
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
