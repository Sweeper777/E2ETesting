//
//  TestReport.swift
//  E2ETesting
//
//  Created by Mulang Su on 20/12/2025.
//

import Markdown

@MainActor
public struct TestReport {
    let suites: [any TestSuite]
    
    public func makeMarkdown(
        includedSeverityLevels: Set<LogSeverity> = [.info, .failure, .success, .warning, .measurement]
    ) -> Document {
        var blocks: [any BlockMarkup] = []
        for suite in suites {
            blocks.append(
                contentsOf: makeMarkdown(for: suite, includedSeverityLevels: includedSeverityLevels)
            )
        }
        return Document(blocks)
    }
    
    private func makeMarkdown<S: TestSuite>(
        for suite: S,
        includedSeverityLevels: Set<LogSeverity>
    ) -> [any BlockMarkup] {
        var blocks: [any BlockMarkup] = []
        blocks.append(Heading(level: 2, parseInlineMarkdown(S.name)))
        for testMethod in suite.testMethods {
            if testMethod.logs.isEmpty {
                continue
            }
            blocks.append(Heading(level: 3, parseInlineMarkdown(testMethod.name)))
            var unorderedList = UnorderedList([])
            for log in testMethod.logs {
                if includedSeverityLevels.contains(log.severity) {
                    unorderedList.appendItem(ListItem(
                        Document(parsing: log.description).blockChildren
                    ))
                }
            }
            blocks.append(unorderedList)
        }
        return blocks
    }
    
    private func parseInlineMarkdown(_ markdown: String) -> [any InlineMarkup] {
        var document = Document(parsing: markdown)
        guard let firstBlock = document.blockChildren.first(where: { _ in true }) else {
            return []
        }
        return firstBlock.children.compactMap { $0 as? InlineMarkup }
    }
}
