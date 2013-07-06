#portfolio
this is a simple sinatra app to help me organize my projects, events, and writing and then display it to the world.

##up and running
if for some god foresaken reason you would like to have a local copy of this, follow these instructions to get up and running.

1. fork and clone this repo.
2. `bundle install`
3. `shotgun` to start a local server
4. `tux` to get a console
5. visit `localhost:9393` to see it in action

##data
projects and events are stored in YAML files, `events.yml` and `project.yml`, respectively. they live in the `db` folder.

##views
the front-end is written in HAML and SASS. i'm using the `haml` gem, along with the `redcarpet` gem so that i can use a `:markdown` HAML filter for markup. the `sass` gem is, not surprisingly, used to let me render `scss`. to get both to work i am using `compass`, since Sinatra can't handle HAML and SASS outta the box.

i am using a somewhat advanced partial helper from [I Did it My Way](https://github.com/daz4126/I-Did-It-My-Way-Partials) that allows me to pass objects. code shown below:
```ruby
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
```