module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances

    def count_instances
      self.instances ||= 0
      self.instances += 1
    end
  end

  module InstanceMethods
    private
    def register_instance
      self.class.count_instances
    end
  end
end