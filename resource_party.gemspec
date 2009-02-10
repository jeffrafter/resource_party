# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{resource_party}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Rafter"]
  s.date = %q{2009-02-09}
  s.description = %q{Simple wrapper for HTTParty for basic operations with a restful resource}
  s.email = %q{jeff@baobabhealth.org}
  s.files = ["LICENSE", "Rakefile", "README", "VERSION.yml", "lib/resource_party.rb"]
  s.homepage = %q{http://github.com/jeffrafter/resource_party}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simplified resource interaction using HTTParty}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jnunemaker-httparty>, [">= 0"])
    else
      s.add_dependency(%q<jnunemaker-httparty>, [">= 0"])
    end
  else
    s.add_dependency(%q<jnunemaker-httparty>, [">= 0"])
  end
end
