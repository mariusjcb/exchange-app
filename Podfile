install! 'cocoapods', :deterministic_uuids => false
platform :ios, '10.0'
source "https://cdn.cocoapods.org/"

$binary_pods = Set.new

def binary_pod(name, *args, **kwargs)
    kwargs_cloned = kwargs.clone
    kwargs_cloned[:binary] = enabled_prebuilt_pods if kwargs_cloned[:binary].nil?
    pod name, *args, **kwargs_cloned

    $binary_pods << name if kwargs_cloned[:binary]
end

def enabled_prebuilt_vendor_pods
    ENV["ENABLE_PREBUILT_POD_LIBS"] == "true"
end

def enabled_prebuilt_pods
    enabled_prebuilt_vendor_pods
end

pods_originally_distributed_as_vendor = [ ]

if enabled_prebuilt_pods
    plugin "cocoapods-binary-cache"
    config_cocoapods_binary_cache(prebuild_job: true,
                                  prebuild_all_vendor_pods: true,
                                  excluded_pods: [],
                                  save_cache_validation_to: ".stats/cocoapods_binary_cache.json")
end

#==================================================================================#
#MARK: - COMPONENTS
#==================================================================================#

def default_pods
    binary_pod 'RxSwift'
    binary_pod 'RxAlamofire'
    binary_pod 'RxCocoa'

    binary_pod 'Alamofire', '~> 4.9'
    binary_pod 'Charts'
end

#==================================================================================#
#MARK: - TARGETS
#==================================================================================#

use_frameworks!
target "Exchange App" do
    default_pods
end

#==================================================================================#
#MARK: - HOOKS
#==================================================================================#

pre_install do |installer|
    must_be_dynamic_frameworks = []

    def make_static(pod)
      pod.instance_variable_set(:@build_type, ::Pod::BuildType.new(linkage: :static, packaging: :framework))
    end

    def make_dynamic(pod)
      pod.instance_variable_set(:@build_type, ::Pod::BuildType.new(linkage: :dynamic, packaging: :framework))
    end

    installer.pod_targets.each do |pod|
      if must_be_dynamic_frameworks.include?(pod.name)
        make_dynamic(pod)
      else
        make_static(pod)
      end
    end
end

post_install do |installer|
    FileUtils.mkdir_p(".stats")
    pods_to_integrate = ($binary_pods - pods_originally_distributed_as_vendor).to_a
    File.open(".stats/pods_to_integrate.txt", "w") { |f| f.puts(pods_to_integrate) }

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
	    xcconfig_path = config.base_configuration_reference.real_path
            xcconfig = File.read(xcconfig_path)
            new_xcconfig = xcconfig.sub('OTHER_LDFLAGS =', 'OTHER_LDFLAGS[sdk=iphone*] =')
            File.open(xcconfig_path, "w") { |file| file << new_xcconfig }

            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = true
       	    config.build_settings['ARCHS'] = 'arm64 arm64e armv7 armv7s x86_64'
        end
    end
end
