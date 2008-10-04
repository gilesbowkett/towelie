%w(find erb rubygems parse_tree ruby2ruby).each {|lib| require lib}
%w(array code_base node_analysis model view).each do |lib|
  require "#{File.dirname(__FILE__) + "/" + lib}"
end

class Towelie
  def initialize
    @model = Model.new
    @view = View.new
  end
  def parse(dir)
    @model.parse(dir)
  end
  def duplicates
    @view.render(:template => "duplicates.erb",
                 :nodes => @model.duplicates,
                 :unique_nodes => @model.duplicates.uniq)
  end
end
