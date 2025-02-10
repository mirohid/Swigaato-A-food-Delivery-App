# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Swigaato' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Add the Firebase pod for Google Analytics
  pod 'FirebaseAnalytics'
  
  # For Analytics without IDFA collection capability, use this pod instead
  # pod ‘Firebase/AnalyticsWithoutAdIdSupport’
  
  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseCore'
  pod 'Firebase'
  
  pod 'GoogleSignIn'
  
  
  # Pods for Swigaato
  
end

post_install do | installer |
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        xcode_base_version = `xcodebuild -version | grep 'Xcode' | awk '{print $2}' | cut -d . -f 1`
        # For xcode 15+ only
        if config.base_configuration_reference && Integer(xcode_base_version) >= 15
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].split('.').first.to_i < 11
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
      end
    end
  end
end
