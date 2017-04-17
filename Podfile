# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
    pod 'lf'
    pod 'NVActivityIndicatorView'
    pod 'EZSwiftExtensions'
    pod 'Firebase'
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    pod 'TagCellLayout', '~> 0.3'
end

target 'Link' do
    use_frameworks!
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
