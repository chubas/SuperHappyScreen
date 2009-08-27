ActionController::Routing::Routes.draw do |map|

  map.root                      :controller => 'pages',   :action => 'main'
  map.register  '/register',    :controller => 'pages',   :action => 'register'
  map.wiki      '/wiki/:page',  :controller => 'pages',   :action => 'wiki'
  map.projects  '/projects',    :controller => 'pages',   :action => 'projects'
end
