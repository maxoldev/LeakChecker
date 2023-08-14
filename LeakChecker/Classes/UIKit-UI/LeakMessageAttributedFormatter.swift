//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

@objc
public class LeakMessageAttributedFormatter: LeakMessageFormatter {

    private enum Spec {
        enum Font {
            static let regular = UIFont.systemFont(ofSize: fontSize)
            static let bold = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
            static let italic = UIFont.italicSystemFont(ofSize: fontSize)
        }
        static let fontSize: CGFloat = 14
        static let toastTextColor = UIColor.black

        static let leakListTextColor: UIColor = {
            if #available(iOS 13, tvOS 13.0, *) {
                return UIColor.label
            } else {
                return UIColor.black
            }
        }()
    }

    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df
    }()

    private static func attributedString(forLeak leak: LeakChecker.DetectedLeak) -> NSAttributedString {
        let resultString = NSMutableAttributedString(
            string: "\(dateFormatter.string(from: leak.date)) ",
            attributes: [.font: Spec.Font.regular]
        )
        resultString.append(
            NSAttributedString(
                string: "<\(leak.objectClass): \(leak.objectPointerString)>",
                attributes: [.font: Spec.Font.bold]
            )
        )
        resultString.append(
            NSAttributedString(
                string: " has not been deallocated after expected \(leak.expectedDeallocationInterval) sec.",
                attributes: [.font: Spec.Font.regular]
            )
        )
        if let context = leak.context {
            resultString.append(
                NSAttributedString(
                    string: " (context: \(context))",
                    attributes: [.font: Spec.Font.regular]
                )
            )
        }
        return resultString
    }

    // MARK: - External
    public static func toastAttributedString(forLeak leak: LeakChecker.DetectedLeak) -> NSAttributedString {
        let resultString = NSMutableAttributedString(string: "Potential leak detected:\n", attributes: [.font: Spec.Font.regular])
        resultString.append(attributedString(forLeak: leak))
        resultString.append(
            NSAttributedString(string: "\n(tap to view the whole leak list)", attributes: [.font: Spec.Font.italic])
        )
        resultString.addAttributes([.foregroundColor: Spec.toastTextColor], range: NSRange(location: 0, length: resultString.length))
        return resultString
    }

    public static func leakListAttributedString(forLeak leak: LeakChecker.DetectedLeak) -> NSAttributedString {
        let resultString = NSMutableAttributedString(attributedString: attributedString(forLeak: leak))
        resultString.addAttributes([.foregroundColor: Spec.leakListTextColor], range: NSRange(location: 0, length: resultString.length))
        return resultString
    }

}
