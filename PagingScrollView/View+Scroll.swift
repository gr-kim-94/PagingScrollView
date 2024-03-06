//
//  View+Scroll.swift
//  PagingScrollView
//
//  Created by 김가람 on 2024/03/06.
//

import SwiftUI

struct PagingScrollViewModifier: ViewModifier {
    let name: String
    let axes: Axis.Set
    let pageSize: CGFloat
    @Binding var page: Int
    let maxPage: Int
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self,
                                    value: geometry.frame(in: .named(name)).origin)
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                var newPage = 0
                
                if axes == .horizontal {
                    if pageSize != 0 {
                        let x = -value.x
                        newPage = Int(x / pageSize)
                    }
                } else if axes == .vertical {
                    if pageSize != 0 {
                        let y = -value.y
                        newPage = Int(y / pageSize)
                    }
                }
                
                // newPage 음수일 경우,
                newPage = max(0, newPage)
                
                // newPage가 maxPage 높을 경우,
                if newPage > maxPage {
                    newPage = maxPage
                }
                
                if page != newPage {
                    page = newPage
                }
            }
    }
}

extension View {
    /// axes == .horizontal인 경우, pageSize width
    /// axes == .vertical인 경우, pageSize height
    func changedPaging(name: String, 
                       axes: Axis.Set = .horizontal,
                       pageSize: CGFloat = 0,
                       page: Binding<Int>,
                       maxPage: Int) -> some View {
        modifier(PagingScrollViewModifier(name: name, axes: axes, pageSize: pageSize, page: page, maxPage: maxPage))
    }
}

// MARK: Scroll Offset PreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}
