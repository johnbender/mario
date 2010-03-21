# Courtesy of Jay Fields and
# http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html
class Object # :nodoc
  def define_class_method(name, &blk)
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
end
