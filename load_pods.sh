export ENABLE_PREBUILT_POD_LIBS=true
export PREBUILD_VENDOR_PODS_JOB=false
export FORCE_PREBUILD_ALL_VENDOR_PODS=false

find ./ -type l -delete
rm -rf DerivedData
rm -rf Pods/*

bundle exec pod binary-cache --cmd=fetch --push_vendor_pods=true
bundle exec pod install
