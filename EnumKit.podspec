Pod::Spec.new do |s|

    s.version = "1.1.2"
    s.ios.deployment_target = '10.0'
    s.osx.deployment_target = '10.10'
    s.name = "EnumKit"
 	s.summary = "Utility library to simplify working with enums in swift"
	s.swift_version = '5.1'
    
  	s.description  = <<-DESC
                   EnumKit is a library that gives you the ability to simply access an enum associated value, without having to use pattern matching. It also offers many utilities available to other swift types, like updatability of an associated value and transformations.
                   
                   EnumKit comes with an extension of Sequence to extend functions like compactMap, flatMap, filter to Sequences of enums cases.
                   DESC
                   
    s.requires_arc = true

    s.license = { :type => "MIT" }
	s.homepage = "https://www.pfrpg.net"
    s.author = { "Giuseppe Lanza" => "gringoire986@gmail.com" }
    s.weak_frameworks = "Combine"
    s.source = {
        :git => "https://github.com/gringoireDM/EnumKit.git",
        :tag => s.version.to_s
    }
    
    s.source_files = "Sources/**/*.swift"
end
