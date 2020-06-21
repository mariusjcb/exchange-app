#!/bin/bash
set -e

export WORKING_DIR=$(PWD)
export TEST_DEVICE=${INTEGRATION_TEST_DEVICE_NAME:-iPhone 8}
export DERIVED_DATA_PATH=${DERIVED_DATA_PATH:-DerivedData}

export ENABLE_PREBUILT_POD_LIBS=true
export PREBUILD_VENDOR_PODS_JOB=true
export FORCE_PREBUILD_ALL_VENDOR_PODS=false

log_section() {
  echo "-------------------------------------------"
  echo "$1"
  echo "-------------------------------------------"
}

check_pod_install_when_prebuilt_enabled() {
  log_section "Checking pod install when prebuilt frameworks are ENABLED..."

  rm -rf Pods
  bundle exec pod binary-cache --cmd=prebuild --push_vendor_pods=true
  bundle exec pod install --ansi || bundle exec pod install --ansi --repo-update
}

xcodebuild_test() {
  xcodebuild \
    -workspace Exchange\ App.xcworkspace \
    -scheme Exchange\ App \
    -configuration Debug \
    -sdk "iphonesimulator" \
    -destination "platform=iOS Simulator,name=${TEST_DEVICE}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    clean \
    test
}

check_xcodebuild_test() {
  log_section "Checking xcodebuild test..."

  if bundle exec xcpretty --version &> /dev/null; then
    set -o pipefail && xcodebuild_test | bundle exec xcpretty
  elif which xcpretty &> /dev/null; then
    set -o pipefail && xcodebuild_test | xcpretty
  else
    xcodebuild_test
  fi
}

check_prebuilt_integration() {
  log_section "Checking pods integration..."

  local should_fail=false
  for pod in $(cat ".stats/pods_to_integrate.txt"); do
    local framework_dir="Pods/${pod}/${pod}.framework"
    if [[ ! -f "${framework_dir}/${pod}" ]]; then
      should_fail=true
      echo "🚩 Prebuilt framework ${pod} was not integrated. Expect to have: ${framework_dir}"
    fi
  done
  if [[ ${should_fail} == "true" ]]; then
    exit 1
  fi
  echo "All good!"
}

run() {
  check_pod_install_when_prebuilt_enabled
  check_xcodebuild_test
  check_prebuilt_integration
}

echo "Working dir: ${WORKING_DIR}"
run
