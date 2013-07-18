Redmine::Plugin.register :redmine_recruting_workgroup do
  name 'Recruting Workgroup plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu :admin_menu, :competences,
    {:controller => :competences, :action => :index}, :caption => :label_competence_plural, :html => {:class => :users}

end
