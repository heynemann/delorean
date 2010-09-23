# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delorean}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bernardo Heynemann"]
  s.date = %q{2010-09-23}
  s.default_executable = %q{delorean}
  s.description = %q{Duration type}
  s.email = %q{heynemann@gmail.com}
  s.executables = ["delorean"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "Gemfile",
     "Makefile",
     "README",
     "Rakefile",
     "VERSION",
     "bin/delorean",
     "delorean.gemspec",
     "features",
     "install.rb",
     "lib/authorization.rb",
     "lib/console.rb",
     "lib/db.rb",
     "lib/domain.rb",
     "lib/messaging.rb",
     "lib/public/css/grid.css",
     "lib/public/img/background-top.png",
     "lib/public/img/background-white.png",
     "lib/public/img/delorean-logo-sm.png",
     "lib/public/img/delorean-logo.png",
     "lib/server.rb",
     "lib/views/about.haml",
     "lib/views/catalogue_list.haml",
     "lib/views/catalogue_new.haml",
     "lib/views/catalogue_show.haml",
     "lib/views/layout.haml",
     "lib/views/style.sass",
     "spec/load_all_tests/load_all_1.txt",
     "spec/load_all_tests/load_all_2.txt",
     "spec/proper_messages_1.txt",
     "spec/spec.opts",
     "spec/spec_db.rb",
     "spec/spec_domain.rb",
     "spec/spec_helper.rb",
     "spec/spec_messaging.rb",
     "spec/spec_server.rb"
  ]
  s.homepage = %q{http://github.com/heynemann/delorean}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Duration type}
  s.test_files = [
    "spec/spec_db.rb",
     "spec/spec_domain.rb",
     "spec/spec_helper.rb",
     "spec/spec_messaging.rb",
     "spec/spec_server.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

