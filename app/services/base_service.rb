class BaseService
  def self.call(*args, &block)
    new(*args).call(&block)
  end

  def call(&block)
    raise NotImplementedError
  end
end