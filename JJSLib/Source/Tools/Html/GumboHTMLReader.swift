//
//  GumboHTMLReader.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/16.
//

import Foundation
import UIKit
//import GumboHTMLTransform
//import YYText

class GumboHTMLReader {
    func readHTML2AttributedString(_ html: String, fontSize: CGFloat = 12) -> NSAttributedString? {
//        let document = OCGumboDocument(htmlString: html)
//        if let document = document, let root = document.rootElement {
//            let attributedString = NSMutableAttributedString()
//            recuriseAnalysisGumboElement(node: root, attributedString: attributedString, fontSize: fontSize)
//            return attributedString as NSAttributedString
//        }
        return nil
    }

//    private func recuriseAnalysisGumboElement(node: OCGumboNode, attributedString: NSMutableAttributedString, fontSize: CGFloat) {
//        for childNode in node.childNodes {
//            if let textNode = childNode as? OCGumboText, textNode.nodeName == "#text" {
//                let subContent = NSMutableAttributedString(string: textNode.nodeValue ?? "")
//                let subRange = NSRange(location: 0, length: subContent.length)
//                var reFontSize: CGFloat = fontSize
//
//                // 字体颜色
//                if let node = textNode.findLastNode(where: { $0.nodeName == "font" }) as? OCGumboElement, let attributes = node.attributes {
//                    for attri in attributes {
//                        if let attribute = attri as? OCGumboAttribute, attribute.name == "color" {
//                            subContent.addAttributes([.foregroundColor: colorFromString(attribute.value)], range: subRange)
//                        }
//                        if let attribute = attri as? OCGumboAttribute, attribute.name == "style" {
//                            let comps = attribute.value.components(separatedBy: ";").compactMap { part -> (String, String)? in
//                                let partData = part.components(separatedBy: ":")
//                                if partData.count == 2 {
//                                    return (partData[0].trimmingIllegaCharacters(), partData[1].trimmingIllegaCharacters())
//                                }
//                                return nil
//                            }
//                            for comp in comps {
//                                switch comp.0 {
//                                case "text-shadow":
//                                    // style="text-shadow: 2pt 2pt 5pt red;"
//                                    let params = comp.1.components(separatedBy: " ")
//                                    var offset: CGSize?
//                                    var radius: Double?
//                                    var color: UIColor?
//                                    if params.count == 3 {
//                                        offset = CGSize(width: params[0].ptValue, height: params[1].ptValue)
//                                        radius = 1
//                                        color = colorFromString(params[2])
//                                    }
//                                    if params.count == 4 {
//                                        offset = CGSize(width: params[0].ptValue, height: params[1].ptValue)
//                                        radius = params[2].ptValue
//                                        color = colorFromString(params[3])
//                                    }
//                                    if let offset = offset, let radius = radius, let color = color {
//                                        let textShadow = YYTextShadow()
//                                        textShadow.color = color
//                                        textShadow.offset = offset
//                                        textShadow.radius = CGFloat(radius)
//                                        subContent.yy_setTextShadow(textShadow, range: subRange)
//                                    }
//                                case "font-size":
//                                    let size = comp.1.ptValue
//                                    if size > 0 {
//                                        reFontSize = CGFloat(size)
//                                        subContent.addAttributes([.font: UIFont.systemFont(ofSize: reFontSize, weight: .regular)], range: subRange)
//                                    }
//                                default:
//                                    break
//                                }
//                            }
//                        }
//                    }
//                }
//                // 下划线
//                if textNode.findLastNode(where: { $0.nodeName == "u" }) != nil {
//                    subContent.addAttributes([.underlineStyle: 1], range: subRange)
//                }
//                // 粗体
//                if textNode.findLastNode(where: { $0.nodeName == "b" || $0.nodeName == "strong" }) != nil {
//                    subContent.addAttributes([.font: UIFont.systemFont(ofSize: reFontSize, weight: .heavy)], range: subRange)
//                }
//                // 删除线
//                if textNode.findLastNode(where: { $0.nodeName == "strike" }) != nil {
//                    subContent.addAttributes([.strikethroughStyle: 1], range: subRange)
//                }
//                // 斜体
//                if textNode.findLastNode(where: { $0.nodeName == "em" || $0.nodeName == "i" }) != nil {
//                    subContent.addAttributes([.obliqueness: 0.2], range: subRange)
//                }
//                // 超链接
//                if let node = textNode.findLastNode(where: { $0.nodeName == "a" }) as? OCGumboElement,
//                   let attributes = node.attributes,
//                   let href = attributes.compactMap({ $0 as? OCGumboAttribute }).first(where: { $0.name == "href" })?.value
//                {
//                    let highlight = YYTextHighlight(backgroundColor: .clear)
//                    highlight.userInfo = ["href": href]
//                    subContent.yy_setTextHighlight(highlight, range: subRange)
//                    subContent.addAttributes([.underlineStyle: 1], range: subRange)
//                }
//                attributedString.append(subContent)
//            }
//            if let element = childNode as? OCGumboElement {
//                // 支持段落和换行（段落未详解）
//                if element.nodeName == "br" || element.nodeName == "p" {
//                    attributedString.append(NSAttributedString(string: "\n"))
//                }
//                recuriseAnalysisGumboElement(node: element, attributedString: attributedString, fontSize: fontSize)
//            }
//        }
//    }
}

private func colorFromString(_ string: String) -> UIColor {
    var hexString = string
    if let tryColorNameHex = HTMLColorNames[string.lowercased()] {
        hexString = tryColorNameHex
    }
    return UIColor(hexString) ?? .black
}

//private extension OCGumboNode {
//    func findLastNode(where predicate: (OCGumboNode) -> Bool) -> OCGumboNode? {
//        var node: OCGumboNode? = self
//        while node != nil {
//            if let node = node, predicate(node) {
//                return node
//            }
//            node = node?.parent
//        }
//        return nil
//    }
//}

private extension String {
    func trimmingIllegaCharacters() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var ptValue: Double {
        let number = (trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted) as NSString).doubleValue
        if hasSuffix("px") {
            return number / Double(UIScreen.main.scale)
        }
        return number
    }
}
