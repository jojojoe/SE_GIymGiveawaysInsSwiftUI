//
//  QGridVer.swift
//  QGrid
//
//  Created by Karol Kulesza on 7/06/19.
//  Copyright © 2019 Q Mobile { http://Q-Mobile.IT }
//
//
import SwiftUI
 

/// A container that presents rows of data arranged in multiple columns.
@available(iOS 13.0, OSX 10.15, *)
public struct QGridVer<Data, Content>: View
where Data : RandomAccessCollection, Content : View, Data.Element : Identifiable {
    private struct QGridVerIndex : Identifiable { var id: Int }
    
    // MARK: - STORED PROPERTIES
    
    private let columns: Int
    private let columnsInLandscape: Int
    private let vSpacing: CGFloat
    private let hSpacing: CGFloat
    private let vPadding: CGFloat
    private let hPadding: CGFloat
    private let isScrollable: Bool
    private let showScrollIndicators: Bool
    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    
    // MARK: - INITIALIZERS
    
    /// Creates a QGridVer that computes its cells from an underlying collection of identified data.
    ///
    /// - Parameters:
    ///     - data: A collection of identified data.
    ///     - columns: Target number of columns for this grid, in Portrait device orientation
    ///     - columnsInLandscape: Target number of columns for this grid, in Landscape device orientation; If not provided, `columns` value will be used.
    ///     - vSpacing: Vertical spacing: The distance between each row in grid. If not provided, the default value will be used.
    ///     - hSpacing: Horizontal spacing: The distance between each cell in grid's row. If not provided, the default value will be used.
    ///     - vPadding: Vertical padding: The distance between top/bottom edge of the grid and the parent view. If not provided, the default value will be used.
    ///     - hPadding: Horizontal padding: The distance between leading/trailing edge of the grid and the parent view. If not provided, the default value will be used.
    ///     - isScrollable: Boolean that determines whether or not the grid should scroll
    ///     - content: A closure returning the content of the individual cell
    public init(_ data: Data,
                columns: Int,
                columnsInLandscape: Int? = nil,
                vSpacing: CGFloat = 10,
                hSpacing: CGFloat = 10,
                vPadding: CGFloat = 10,
                hPadding: CGFloat = 10,
                isScrollable: Bool = true,
                showScrollIndicators: Bool = false,
                content: @escaping (Data.Element) -> Content) {
        self.data = data.map { $0 }
        self.content = content
        self.columns = max(1, columns)
        self.columnsInLandscape = columnsInLandscape ?? max(1, columns)
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.vPadding = vPadding
        self.hPadding = hPadding
        self.isScrollable = isScrollable
        self.showScrollIndicators = showScrollIndicators
    }
    
    // MARK: - COMPUTED PROPERTIES
    
    private var rows: Int {
        data.count / self.cols
    }
    
    private var cols: Int {
        #if os(tvOS)
        return columnsInLandscape
        #elseif os(macOS)
        return columnsInLandscape
        #else
        return UIDevice.current.orientation.isLandscape ? columnsInLandscape : columns
        #endif
    }
    
    /// Declares the content and behavior of this view.
    public var body : some View {
        GeometryReader { geometry in
            Group {
                if !self.data.isEmpty {
                    if self.isScrollable {
                        ScrollView(showsIndicators: self.showScrollIndicators) {
                            self.content_ver(using: geometry)
                        }
                    } else {
                        content_ver(using: geometry)
                        
                    }
                }
            }
            .padding(.horizontal, self.hPadding)
            .padding(.vertical, self.vPadding)
        }
    }
    
}



// MARK: - 垂直
extension QGridVer {
    // MARK: - `BODY BUILDER` 💪 FUNCTIONS
    private func content_ver(using geometry: GeometryProxy) -> some View {
        VStack(spacing: self.vSpacing) {
            ForEach((0..<self.rows).map { QGridVerIndex(id: $0) }) { row in
                self.rowAtIndex_ver(row.id * self.cols,
                                geometry: geometry)
            }
            // Handle last row
            if (self.data.count % self.cols > 0) {
                self.rowAtIndex_ver(self.cols * self.rows,
                                geometry: geometry,
                                isLastRow: true)
            }
        }
    }
    
    private func rowAtIndex_ver(_ index: Int,
                            geometry: GeometryProxy,
                            isLastRow: Bool = false) -> some View {
        HStack(spacing: self.hSpacing) {
            ForEach((0..<(isLastRow ? data.count % cols : cols))
                        .map { QGridVerIndex(id: $0) }) { column in
                self.content(self.data[index + column.id])
                    .frame(width: self.contentWidthFor_ver(geometry))
            }
            if isLastRow { Spacer() }
        }
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    private func contentWidthFor_ver(_ geometry: GeometryProxy) -> CGFloat {
        let hSpacings = hSpacing * (CGFloat(self.cols) - 1)
        let width = geometry.size.width - hSpacings - hPadding * 2
        return width / CGFloat(self.cols)
    }
}
