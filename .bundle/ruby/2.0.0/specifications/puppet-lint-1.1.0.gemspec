# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "puppet-lint"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Sharpe"]
  s.date = "2014-09-23"
  s.description = "Checks your Puppet manifests against the Puppetlabs\n  style guide and alerts you to any discrepancies."
  s.email = "tim@sharpe.id.au"
  s.executables = ["puppet-lint"]
  s.files = ["bin/puppet-lint"]
  s.homepage = "https://github.com/rodjek/puppet-lint/"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Ensure your Puppet manifests conform with the Puppetlabs style guide"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_development_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
    else
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<rspec-its>, ["~> 1.0"])
      s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<rspec-its>, ["~> 1.0"])
    s.add_dependency(%q<rspec-collection_matchers>, ["~> 1.0"])
  end
end
