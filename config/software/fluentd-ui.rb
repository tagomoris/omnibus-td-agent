name "fluentd-ui"
default_version 'b3800e16c66abc098783ea96b99a33fd7aae9784'

dependency "ruby"

source :git => 'https://github.com/fluent/fluentd-ui.git'
relative_path "fluentd-ui"

build do
  ui_gems_path = File.expand_path(File.join(Omnibus::Config.project_root, 'ui_gems'))
  if File.exist?(ui_gems_path)
    Dir.glob(File.join(ui_gems_path, '*.gem')).sort.each { |gem_path|
      gem "install --no-ri --no-rdoc #{gem_path}"
    }
    rake "build", :env => {'BUNDLE_GEMFILE' => 'Gemfile.production'}
    gem "install --no-ri --no-rdoc pkg/fluentd-ui-*.gem"
    td_agent_bin_dir = File.join(project.install_dir, 'embedded', 'bin')
    # Avoid deb's start-stop-daemon issue by providing another ruby binary. Will remove this ad-hoc code
    copy(File.join(td_agent_bin_dir, "ruby"), File.join(td_agent_bin_dir, "td_agent_ui_ruby"))
  end
end
