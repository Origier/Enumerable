module Enumerable

  def my_each
    for i in self
      yield i
    end
  end

  def my_each_with_index
    i = 0
    for j in self
      yield j, i
      i += 1
    end
  end

  def my_select
    arry = []
    for i in self
      arry << i if yield i
    end
    arry
  end

  def my_all?(pattern = nil)
    for i in self
      if block_given?
        if yield i
          next
        else
          return false
        end
      elsif pattern != nil
        if pattern.is_a?(Regexp)
          if pattern =~ i
            next
          else
            return false
          end
        else
          if i.is_a?(pattern)
            next
          else
            return false
          end
        end
      else
        return self.my_all?{|x| x}
      end
    end
    return true
  end

  def my_any?(pattern = nil)
    for i in self
      if block_given?
        if yield i
          return true
        else
          next
        end
      elsif pattern != nil
        if pattern.is_a?(Regexp)
          if pattern =~ i
            return true
          else
            next
          end
        else
          if i.is_a?(pattern)
            return true
          else
            next
          end
        end
      else
        return self.my_any?{|x| x}
      end
    end
    return false
  end

  def my_none?(pattern = nil)
    if block_given?
      !self.my_any?{|x| yield x}
    else
      !self.my_any?(pattern)
    end
  end

  def my_count(item = nil)
    count = 0
    for i in self
      if item != nil
        count += 1 if i == item
      elsif block_given?
        count += 1 if yield i
      else
        count += 1
      end
    end
    count
  end

  def my_map(proc = nil)
    arry = []
    if proc != nil
      for i in self
        element = proc.call(i)
        arry << element
      end
    else
      for i in self
        element = yield i
        arry << element
      end
    end
    arry
  end

  def my_inject(init = nil)
    if init == nil
      initialize_num = true
    elsif init.is_a?(Symbol)
      return self.my_inject{|sum, n| sum.method(init).call(n)}
    else
      sum = init
      initialize_num = false
    end
    for i in self
      if initialize_num
        sum = i
        initialize_num = false
      else
        sum = yield sum, i  
      end
    end
    sum
  end
end