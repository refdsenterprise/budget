//
//  DataDocument.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import SwiftUI
import UniformTypeIdentifiers

public struct DataDocument: FileDocument {
    public static var readableContentTypes: [UTType] { [.json] }
    public var codable: String

    public init(codable: String = "") {
        self.codable = codable
    }

    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else { throw CocoaError(.fileReadCorruptFile) }
        self.codable = String(data: data, encoding: .utf8) ?? ""
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        if let data = codable.data(using: .utf8) { return FileWrapper(regularFileWithContents: data) }
        throw CocoaError(.fileWriteFileExists)
    }
}
