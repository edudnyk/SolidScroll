//
//  ContentView.swift
//  SolidScrollDemo
//
//  Created by Eugene Dudnyk on 20/10/2021.
//
//  MIT License
//
//  Copyright (c) 2021 Eugene Dudnyk
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI
import SolidScroll

struct ContentView: View {
    var config = ScrollViewConfig()
    @State var scrollViewProxy: SolidScrollViewProxy?
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacing3x) {
                SolidScrollView(config) {
                    VStack(spacing: 0) {
                        Color.orange.frame(height: 200)
                        Color.black.frame(height: 200)
                        Color.blue.frame(height: 200)
                        Color.yellow.frame(height: 200)
                    }
                }
                Button("Scroll to 3/4 of the content height via proxy") {
                    guard let scrollViewProxy = scrollViewProxy else { return }
                    let contentOffset = CGPoint(x: 0, y: min(scrollViewProxy.contentSize.height * 3.0 / 4, scrollViewProxy.maxContentOffset.y))
                    scrollViewProxy.setContentOffset(contentOffset, animated: true, completion: { completed in
                        print("Scrolled via proxy to \(contentOffset)! Completed: \(completed)")
                    })
                }
                .applyButtonStyle(isSelected: true)
                NavigationLink(destination: PagingContentView()) {
                    Text("See paging")
                        .applyButtonStyle(isSelected: true)
                }
            }
            .onPreferenceChange(ContainedScrollViewKey.self) {
                scrollViewProxy = $0
            }
            .navigationBarTitle(Text("Solid Scroll Demo"))
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}

struct PagingContentView: View {
    @State var currentPage: Int = 0
    let config: PagingViewConfig
    
    init() {
        var config = PagingViewConfig()
        config.direction = .horizontal
        config.size = 100
        config.margin = 0
        config.spacing = 0
        self.config = config
    }

    var body: some View {
        PagingView(config: config, page: $currentPage, views: Array(0...27).map { page(at: $0) })
            .navigationBarTitle(Text("Solid Paging Demo"))
    }
    
    @ViewBuilder
    func page(at index: Int) -> some View {
        Text("Page \(index)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor(at: index))
            .foregroundColor(foregroundColor(at: index))
    }
    
    func backgroundColor(at index: Int) -> Color {
        let indexMod = (index % 4)
        switch indexMod {
        case 0: return Color.orange
        case 1: return Color.black
        case 2: return Color.blue
        case 3: return Color.yellow
        default: return Color.clear
        }
    }
    
    func foregroundColor(at index: Int) -> Color {
        let indexMod = (index % 4)
        switch indexMod {
        case 1: return Color.white
        default: return Color.black
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
