//
//  DataDocument.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DataDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var codable: String

    init(codable: String = "") {
        self.codable = codable
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else { throw CocoaError(.fileReadCorruptFile) }
        self.codable = String(data: data, encoding: .utf8) ?? ""
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        if let data = codable.data(using: .utf8) { return FileWrapper(regularFileWithContents: data) }
        throw CocoaError(.fileWriteFileExists)
    }
}
