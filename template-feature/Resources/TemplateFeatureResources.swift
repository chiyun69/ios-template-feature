import Foundation

public final class TemplateFeatureResources {
    public static let bundle: Bundle = {
        // For CocoaPods resource bundles, the bundle is typically named after the pod
        let bundleName = "template-feature"
        
        // First, try to find the resource bundle in the framework bundle
        let frameworkBundle = Bundle(for: TemplateFeatureResources.self)
        
        if let bundleURL = frameworkBundle.url(forResource: bundleName, withExtension: "bundle"),
           let resourceBundle = Bundle(url: bundleURL) {
            return resourceBundle
        }
        
        // Fallback to the framework bundle itself
        return frameworkBundle
    }()
}