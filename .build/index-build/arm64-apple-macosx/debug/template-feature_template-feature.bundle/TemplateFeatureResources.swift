import Foundation
import UIKit

public final class TemplateFeatureResources {
    public static let bundle: Bundle = {
        // Get the bundle containing this class
        let currentBundle = Bundle(for: TemplateFeatureResources.self)
        
        // Try different bundle resolution strategies based on integration method
        
        // 1. Swift Package Manager - resources are in the module bundle
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        
        // 2. CocoaPods with resource bundles
        let cocoapodsBundleNames = [
            "template-feature-resources",  // Updated bundle name from podspec
            "template-feature",            // Original bundle name for backward compatibility
            "template_feature"             // Alternative naming
        ]
        
        for bundleName in cocoapodsBundleNames {
            if let bundleURL = currentBundle.url(forResource: bundleName, withExtension: "bundle"),
               let resourceBundle = Bundle(url: bundleURL) {
                return resourceBundle
            }
        }
        
        // 3. Direct framework integration - resources are in the main bundle
        if let bundleURL = currentBundle.resourceURL {
            // Check if resources exist directly in the framework bundle
            let testImagePath = bundleURL.appendingPathComponent("portrait.jpg")
            if FileManager.default.fileExists(atPath: testImagePath.path) {
                return currentBundle
            }
        }
        
        // 4. Fallback to the main app bundle (development/testing scenarios)
        let mainBundle = Bundle.main
        if let _ = mainBundle.path(forResource: "portrait", ofType: "jpg") {
            return mainBundle
        }
        
        // 5. Final fallback to current bundle
        return currentBundle
        #endif
    }()
    
    /// Helper method to get image from the resource bundle
    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    /// Helper method to get file URL from the resource bundle
    public static func url(forResource name: String, withExtension ext: String?) -> URL? {
        return bundle.url(forResource: name, withExtension: ext)
    }
}