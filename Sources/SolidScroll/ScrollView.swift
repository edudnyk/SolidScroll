//
//  ScrollView.swift
//  SolidScroll
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

/// A configuration which defines most of UIScrollView-like properties for the native `SwiftUI._ScrollView`
///
/// Definition of `SwiftUI._ScrollViewGestureProvider`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public protocol _ScrollViewGestureProvider {
///   func scrollableDirections(proxy: _ScrollViewProxy) -> _EventDirections
///   func gestureMask(proxy: _ScrollViewProxy) -> GestureMask
/// }
///
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// extension _ScrollViewGestureProvider {
///   public func defaultScrollableDirections(proxy: _ScrollViewProxy) -> _EventDirections
///   public func defaultGestureMask(proxy: _ScrollViewProxy) -> GestureMask
///   public func scrollableDirections(proxy: _ScrollViewProxy) -> _EventDirections
///   public func gestureMask(proxy: _ScrollViewProxy) -> GestureMask
/// }
/// ```
///
/// Definition of `SwiftUI._ScrollLayout`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _ScrollLayout : Equatable {
///   public var contentOffset: CGPoint
///   public var size: CGSize
///   public var visibleRect: CGRect
///   public init(contentOffset: CGPoint, size: CGSize, visibleRect: CGRect)
///   public static func == (a: _ScrollLayout, b: _ScrollLayout) -> Bool
/// }
/// ```
///
/// Definition of `SwiftUI._ScrollViewConfig`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _ScrollViewConfig {
///   public static let decelerationRateNormal: Double
///   public static let decelerationRateFast: Double
///   public enum ContentOffset {
///     case initially(CGPoint)
///     case binding(Binding<CGPoint>)
///   }
///   public var contentOffset: _ScrollViewConfig.ContentOffset
///   public var contentInsets: EdgeInsets
///   public var decelerationRate: Double
///   public var alwaysBounceVertical: Bool
///   public var alwaysBounceHorizontal: Bool
///   public var gestureProvider: _ScrollViewGestureProvider
///   public var stopDraggingImmediately: Bool
///   public var isScrollEnabled: Bool
///   public var showsHorizontalIndicator: Bool
///   public var showsVerticalIndicator: Bool
///   public var indicatorInsets: EdgeInsets
///   public init()
/// }
/// ```
public typealias ScrollViewConfig = _ScrollViewConfig

/// A proxy which is returned on change of ``ContainedScrollViewKey`` native SwiftUI preference.
///
/// Definition of `SwiftUI._ScrollViewProxy`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _ScrollViewProxy : Equatable {
///   public var config: _ScrollViewConfig     { get }
///   public var contentOffset: CGPoint        { get set }
///   public var minContentOffset: CGPoint     { get }
///   public var maxContentOffset: CGPoint     { get }
///   public var contentSize: CGSize           { get }
///   public var pageSize: CGSize              { get }
///   public var visibleRect: CGRect           { get }
///   public var isDragging: Bool              { get }
///   public var isDecelerating: Bool          { get }
///   public var isScrolling: Bool             { get }
///   public var isScrollingHorizontally: Bool { get }
///   public var isScrollingVertically: Bool   { get }
///   public func setContentOffset(_ newOffset: CGPoint, animated: Bool, completion: ((Bool) -> Void)? = nil)
///   public func scrollRectToVisible(_ rect: CGRect, animated: Bool, completion: ((Bool) -> Void)? = nil)
///   public func contentOffsetOfNextPage(_ directions: _EventDirections) -> CGPoint
///   public static func == (lhs: _ScrollViewProxy, rhs: _ScrollViewProxy) -> Bool
/// }
/// ```
public typealias SolidScrollViewProxy = _ScrollViewProxy

extension _ContainedScrollViewKey: PreferenceKey {}

/// A preference key that allows to retrieve a ``ScrollViewProxy`` of a sibling scrollview via native SwiftUI APIs.
///
/// Definition of `SwiftUI._ContainedScrollViewKey`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _ContainedScrollViewKey {
///   public typealias Value = _ScrollViewProxy?
///   public static func reduce(value: inout _ContainedScrollViewKey.Value, nextValue: () -> _ContainedScrollViewKey.Value)
/// }
/// ```
/// 
/// Usage:
///
/// ```swift
/// struct ContentView: View {
///   var config = ScrollViewConfig()
///   @State var scrollViewProxy: SolidScrollViewProxy?
///
///   var body: some View {
///     VStack(spacing: 0) {
///       SolidScrollView(config) {
///         VStack(spacing: 0) {
///           Color.red.frame(height: 200)
///           Color.green.frame(height: 200)
///           Color.blue.frame(height: 200)
///           Color.black.frame(height: 200)
///         }
///       }
///       Button("Scroll to 3/4 of the content height via proxy") {
///         guard let scrollViewProxy = scrollViewProxy else { return }
///         let contentOffset = CGPoint(x: 0, y: min(scrollViewProxy.contentSize.height * 3.0 / 4, scrollViewProxy.maxContentOffset.y))
///         scrollViewProxy.setContentOffset(contentOffset, animated: true, completion: { completed in
///           print("Scrolled via proxy to \(contentOffset)! Completed: \(completed)")
///         })
///       }
///     }
///     .onPreferenceChange(ContainedScrollViewKey.self) {
///       scrollViewProxy = $0
///     }
///   }
/// }
/// ```
public typealias ContainedScrollViewKey = _ContainedScrollViewKey

/// A content provider that wraps the content into aligning layout with preferred horizontal and vertical alignment inside of scroll view.
///
/// Definition of `SwiftUI._Velocity`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// @frozen public struct _Velocity<Value> : Equatable where Value : Equatable {
///   public var valuePerSecond: Value
///   @inlinable public init(valuePerSecond: Value) {
///         self.valuePerSecond = valuePerSecond
///     }
///   public static func == (a: SwiftUI._Velocity<Value>, b: SwiftUI._Velocity<Value>) -> Bool
/// }
/// ```
///
/// Definition of `SwiftUI._ScrollableContentProvider`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public protocol _ScrollableContentProvider {
///   associatedtype ScrollableContent : View
///   var scrollableContent: Self.ScrollableContent { get }
///   associatedtype Root : View
///   func root(scrollView: _ScrollView<Self>.Main) -> Self.Root
///   func decelerationTarget(contentOffset: CGPoint, originalContentOffset: CGPoint, velocity: _Velocity<CGSize>, size: CGSize) -> CGPoint?
/// }
/// ```
///
/// Definition of `SwiftUI._AligningContentProvider`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _AligningContentProvider<Content> : _ScrollableContentProvider where Content : View {
///   public var content: Content
///   public var horizontal: TextAlignment?
///   public var vertical: _VAlignment?
///   public init(content: Content, horizontal: TextAlignment? = nil, vertical: _VAlignment? = nil)
///   public var scrollableContent: ModifiedContent<Content, _AligningContentProvider<Content>.AligningContentProviderLayout> { get }
///   public struct AligningContentProviderLayout {
///     public typealias AnimatableData = EmptyAnimatableData
///     public typealias Body = Never
///   }
///   public typealias Root = _ScrollViewRoot<_AligningContentProvider<Content>>
///   public typealias ScrollableContent = ModifiedContent<Content, _AligningContentProvider<Content>.AligningContentProviderLayout>
/// }
/// ```
public typealias AligningContentProvider = _AligningContentProvider

/// A liberated scroll view of SwiftUI.
///
/// Definition of `SwiftUI._ScrollView`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _ScrollView<Provider> : View where Provider : _ScrollableContentProvider {
///   public var contentProvider: Provider
///   public var config: _ScrollViewConfig
///   public init(contentProvider: Provider, config: _ScrollViewConfig = _ScrollViewConfig())
///   @_Concurrency.MainActor(unsafe) public var body: some View {
///     get
///   }
///   public struct Main : View {
///     public typealias Body = Never
///   }
///   public typealias Body = @_opaqueReturnTypeOf("$s7SwiftUI11_ScrollViewV4bodyQrvp", 0) __<Provider>
/// }
/// ```
///
/// Usage:
///
/// ```swift
/// struct ContentView: View {
///   var config = ScrollViewConfig()
///   @State var scrollViewProxy: SolidScrollViewProxy?
///
///   var body: some View {
///     VStack(spacing: 0) {
///       SolidScrollView(config) {
///         VStack(spacing: 0) {
///           Color.red.frame(height: 200)
///           Color.green.frame(height: 200)
///           Color.blue.frame(height: 200)
///           Color.black.frame(height: 200)
///         }
///       }
///       Button("Scroll to 3/4 of the content height via proxy") {
///         guard let scrollViewProxy = scrollViewProxy else { return }
///         let contentOffset = CGPoint(x: 0, y: min(scrollViewProxy.contentSize.height * 3.0 / 4, scrollViewProxy.maxContentOffset.y))
///         scrollViewProxy.setContentOffset(contentOffset, animated: true, completion: { completed in
///           print("Scrolled via proxy to \(contentOffset)! Completed: \(completed)")
///         })
///       }
///     }
///     .onPreferenceChange(ContainedScrollViewKey.self) {
///       scrollViewProxy = $0
///     }
///   }
/// }
/// ```
public typealias SolidScrollView = _ScrollView

extension SolidScrollView {
    /// Creates a new instance that's scrollable in the direction of the given
    /// axis and can show indicators while scrolling.
    ///
    /// - Parameters:
    ///   - axes: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset, in a way
    ///     suitable for the platform. The default value for this parameter is
    ///     `true`.
    ///   - content: The view builder that creates the scrollable view.
    public init<Content: View>(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) where Provider == AligningContentProvider<Content> {
        var config = ScrollViewConfig()
        config.showsHorizontalIndicator = axes.contains(.horizontal) && showsIndicators
        config.showsVerticalIndicator = axes.contains(.vertical) && showsIndicators
        let contentProvider = AligningContentProvider(content: content(), horizontal: .center, vertical: .center)
        self.init(contentProvider: contentProvider, config: config)
    }
    
    public init<Content: View>(_ config: ScrollViewConfig = ScrollViewConfig(), @ViewBuilder content: () -> Content) where Provider == AligningContentProvider<Content> {
        let contentProvider = AligningContentProvider(content: content(), horizontal: .center, vertical: .center)
        self.init(contentProvider: contentProvider, config: config)
    }
}

/// A configuration which defines pagination properties for the native `SwiftUI._PagingView`
///
/// Definition of `SwiftUI._PagingViewConfig`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _PagingViewConfig : Equatable {
///   public enum Direction {
///     case vertical
///     case horizontal
///     public static func == (a: _PagingViewConfig.Direction, b: _PagingViewConfig.Direction) -> Bool
///     public func hash(into hasher: inout Hasher)
///     public var hashValue: Int {
///       get
///     }
///   }
///   public var direction: _PagingViewConfig.Direction
///   public var size: CGFloat?
///   public var margin: CGFloat
///   public var spacing: CGFloat
///   public var constrainedDeceleration: Bool
///   public init(direction: _PagingViewConfig.Direction = .horizontal, size: CGFloat? = nil, margin: CGFloat = 0, spacing: CGFloat = 0, constrainedDeceleration: Bool = true)
///   public static func == (a: _PagingViewConfig, b: _PagingViewConfig) -> Bool
/// }
public typealias PagingViewConfig = _PagingViewConfig

/// A liberated paging view of SwiftUI.
///
/// Definition of `SwiftUI._PagingView`
///
/// ```swift
/// @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
/// public struct _PagingView<Views> : View where Views : RandomAccessCollection, Views.Element : View, Views.Index : Hashable {
///   public var views: Views
///   public var page: Binding<Views.Index>?
///   public var config: _PagingViewConfig
///   public var scrollViewConfig: _ScrollViewConfig
///   public init(config: _PagingViewConfig = _PagingViewConfig(), page: Binding<Views.Index>? = nil, views: Views)
///   public init(direction: _PagingViewConfig.Direction, page: Binding<Views.Index>? = nil, views: Views)
///   @_Concurrency.MainActor(unsafe) public var body: some View {
///     get
///   }
///   public typealias Body = @_opaqueReturnTypeOf("$s7SwiftUI11_PagingViewV4bodyQrvp", 0) __<Views>
/// }
/// ```
///
/// Usage:
///
/// ```swift
/// struct PagingContentView: View {
///   @State var currentPage: Int = 0
///   let config: PagingViewConfig
///
///   init() {
///     var config = PagingViewConfig()
///     config.direction = .horizontal
///     config.size = 100
///     config.margin = 0
///     config.spacing = 0
///     self.config = config
///   }
///
///   var body: some View {
///     PagingView(config: config, page: $currentPage, views: Array(0...10).map { page(at: $0) })
///   }
///
///   @ViewBuilder
///   func page(at index: Int) -> some View {
///     Text("Page \(index)")
///       .frame(maxWidth: .infinity, maxHeight: .infinity)
///       .background(backgroundColor(at: index))
///   }
///
///   func backgroundColor(at index: Int) -> Color {
///     let indexMod = (index % 3)
///     switch indexMod {
///     case 0: return Color.red
///     case 1: return Color.green
///     case 2: return Color.blue
///     default: return Color.clear
///     }
///   }
/// }
/// ```
public typealias PagingView = _PagingView
