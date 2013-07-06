require 'bundler'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Portfolio
  class App < Sinatra::Application

    #configure
    configure do
      set :root, File.dirname(__FILE__)
      set :public_folder, 'public'

      Compass.configuration do |config|
        config.project_path = File.dirname(__FILE__)
        config.sass_dir = 'views'
      end

      set :haml, { :format => :html5 }
      set :sass, Compass.sass_engine_options
      set :scss, Compass.sass_engine_options
    end

    #filters
    before do
      @projects = YAML::load(File.open('db/projects.yml'))
      @events = YAML::load(File.open('db/events.yml'))
    end

    #routes
    get '/' do
      haml :index
    end

    get "/custom.css" do
      scss :styles
    end

    #helpers
    helpers do
      def partial(template,locals=nil)
        if template.is_a?(String) || template.is_a?(Symbol)
          template=('_' + template.to_s).to_sym
        else
          locals=template
          template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym
        end
        if locals.is_a?(Hash)
          haml(template,{:layout => false},locals)      
        elsif locals
          locals=[locals] unless locals.respond_to?(:inject)
          locals.inject([]) do |output,element|
            output <<     haml(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
          end.join("\n")
        else 
          haml(template,{:layout => false})
        end
    end
    end

  end
end
