//
//  ContentView.swift
//  PagingScrollView
//
//  Created by 김가람 on 2024/03/06.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    private static let kPagingScrollName = "PAGING_SCROLL_NAME"
    
    let page: [PageData] = [PageData(imageName: "globe", title: "Hello", color: .blue),
                            PageData(imageName: "globe.americas.fill", title: ", ", color: .red),
                            PageData(imageName: "globe.desk.fill", title: "world!", color: .yellow)]
    
    var isPagingEnabled: Bool {
        !page.isEmpty
    }
    
    @State var currentPage: Int = 0
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 0) {
                        ForEach(page, id: \.self) { value in
                            VStack {
                                Image(systemName: value.imageName)
                                    .imageScale(.large)
                                    .foregroundStyle(.white)
                                Text(value.title)
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background {
                                value.color
                            }
                        }
                        .frame(width: proxy.size.width,
                               height: proxy.size.height)
                    }
                    .changedPaging(name: Self.kPagingScrollName,
                                   pageSize: proxy.size.width,
                                   page: $currentPage,
                                   maxPage: page.count-1)
                }
                .introspect(.scrollView, on: .iOS(.v15, .v16, .v17)) { scrollView in
                    scrollView.isScrollEnabled = isPagingEnabled
                    scrollView.isPagingEnabled = isPagingEnabled
                }
                .coordinateSpace(name: Self.kPagingScrollName)
            }
            
            if isPagingEnabled {
                HStack(spacing: 9) {
                    ForEach(0..<page.count, id: \.self) { page in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(currentPage == page ? .cyan : .gray)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
