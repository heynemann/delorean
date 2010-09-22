# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{delorean}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bernardo Heynemann"]
  s.date = %q{2010-09-22}
  s.description = %q{delorean is a message-driven document database from the future}
  s.email = %q{heynemann @nospam@ gmail.com}
  s.extra_rdoc_files = ["lib/authorization.rb", "lib/console.rb", "lib/db.rb", "lib/domain.rb", "lib/messaging.rb", "lib/public/css/grid.css", "lib/public/img/background-top.png", "lib/public/img/background-white.png", "lib/public/img/delorean-logo-sm.png", "lib/public/img/delorean-logo.png", "lib/server.rb", "lib/views/about.haml", "lib/views/catalogue_list.haml", "lib/views/catalogue_new.haml", "lib/views/catalogue_show.haml", "lib/views/layout.haml", "lib/views/style.sass"]
  s.files = ["lib/authorization.rb", "lib/console.rb", "lib/db.rb", "lib/domain.rb", "lib/messaging.rb", "lib/public/css/grid.css", "lib/public/img/background-top.png", "lib/public/img/background-white.png", "lib/public/img/delorean-logo-sm.png", "lib/public/img/delorean-logo.png", "lib/server.rb", "lib/views/about.haml", "lib/views/catalogue_list.haml", "lib/views/catalogue_new.haml", "lib/views/catalogue_show.haml", "lib/views/layout.haml", "lib/views/style.sass", "delorean.gemspec", "Rakefile"]
  s.homepage = %q{http://github.com/heynemann/delorean}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Delorean", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{delorean}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{delorean is a message-driven document database from the future}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
