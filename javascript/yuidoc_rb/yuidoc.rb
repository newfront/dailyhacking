#!/usr/bin/env ruby
$: << File.join(File.dirname(__FILE__), "")

$config = {}
$config['yuihome'] = "yuidoc"
$config['script'] = "bin/yuidoc.py"
$config['in_dir'] = "."
$config['data_dir'] = "data"
$config['out_dir'] = "doc"
$config['template_dir'] = "template"
$config['project_version'] = "1.0.0"
$config['yui_version'] = 2

# Take arguments
$args = ARGV

def grab_arguments(arguments)
  unless arguments.nil?
    # check what arguments we have
    # can be: 'yuihome','script','in_dir','data_dir','out_dir','templates_dir','project_version','yui_version'
    $vals = {}
    arguments.each{|arg|
      # arg can be split on = or :
      k,v = arg.to_s.split(/[=|:]/)
      $vals[k] = v
    }
    return $vals
  end
  return nil
end

def build_command
  cmd = $config['yuihome']+"/"+$config['script']+" "
  cmd += !$args['in_dir'].nil? ? $args['in_dir'] : $config['in_dir']
  cmd += " -p "
  cmd += !$args['data_dir'].nil? ? $args['data_dir'] : $config['data_dir']
  cmd += " -o "
  cmd += !$args['out_dir'].nil? ? $args['out_dir'] : $config['out_dir']
  cmd += " -t #{$config['yuihome']}/"
  cmd += !$args['template_dir'].nil? ? $args['template_dir'] : $config['template_dir']
  cmd += " -v "
  cmd += !$args['project_version'].nil? ? $args['project_version'] : $config['project_version']
  cmd += " -Y "
  cmd += !$args['yui_version'].nil? ? $args['yui_version'].to_s : $config['yui_version'].to_s
  return cmd
end

$args = grab_arguments($args)

@cmd = build_command
puts @cmd
# Execute Command

puts "EXECUTING\n"
puts "---------------------------------\n"
%x[#{@cmd}]
puts "\n---------------------------------\n"
puts "FINISHED"