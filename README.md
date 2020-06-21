# Exchange App

## Pre-Requirements

 - CocoaPods, v1.9+
 - Ruby, v2.6+ **(for Cocoapods)**

## Compatibility:
 - Xcode 11+
 - MacOS 15.0+ (for **Mac Catalyst**)
 - iOS 10+

## Install Cocoapods Plugins

Because of SIP (System Integrity Protection) activated in macOS Catalina, we need to install vendor gems in our source, that's because /usr/bin is read-only.

    bundle config set path 'vendor/bundle'

Now we can install Cocoapods plugins as following:

    bundle install

## Install Pods
To install pods you can use recommended steps from cocoapods-binary-cache documentation or simply run the following bash script from root directory of the project. This script will install pods, will do a build phase and then will run all unit tests:

    ./install.sh

## How to install Ruby and Bundler
First of all we need to install command line tools for xcode. Even you already have those command tools installed  I would recommend to run it again just to be sure you have the latest version installed. **It will take ~4min**

    xcode-select --install

Install Homebrew and install ruby:

    /usr/bin/ruby -e  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    
    brew install ruby
    echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile

After all we need to install bundle gem:

    gem install  --user-install bundler
    ruby -v
This command should have an output like this:

    ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-darwin19]

Now we need to provide access to bundler gem so append the following path to bash profile, replacing X.X with your ruby version (e.g. 2.7). **Be aware, it should be .gem/ruby/2.7.0/ even your ruby version is 2.7.1**

    echo 'export PATH="$HOME/.gem/ruby/X.X.0/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_pr
