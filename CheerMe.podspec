Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "CheerMe"
s.summary = "Rewards"
s.requires_arc = true

# 2
s.version = "0.0.6"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Neeraj Negi" => "neerajnegi@beyondroot.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/beyond-root-dev/CheerMe"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/beyond-root-dev/CheerMe.git",
             :tag => "#{s.version}" }

# 7
s.source_files = "CheerMe/**/*.{swift}"

# 8
s.resources = "CheerMe/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 9
s.swift_version = "5"

end
