require 'pathname'
$:.unshift(Pathname.new(__FILE__).dirname)

module VagrantNodes

  VAGRANT_HOST_FILES = './vm_defs'

  def include_file(name, context)
    full_name = get_ruby_file(name)
    fail ArgumentError, "file #{name} not found" unless full_name
    context.eval(IO.read(full_name), full_name)
  end
  alias_method :vagrant_node, :include_file

  private

  # @private
  def get_ruby_file(name)
    name = Pathname(name)
    return name.to_s if name.absolute?
    name = Pathname.new(name.to_s + '.rb') unless name.extname == '.rb'
    name = name.to_s
    path = $LOAD_PATH.find { |dir| File.exist?(File.join(dir, name)) }
    path && File.join(path, name)
  end
end

