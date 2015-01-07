# This code comes from batsd - I just decided to put this in a child
# class rather than re-opening Array.
class Honeybadger::Array < Array
  # Calculates the sum of values in the array
  def sum
   inject( nil ) { |sum,x| sum ? sum+x : x };
  end

  # Calculates the arithmetic mean of values in the array
  def mean
   self.sum.to_f / self.length
  end

  # Calculates the median of values in the array
  def median
   self.sort[self.length/2]
  end

  # Calculates the value of the upper percentile of values
  # in the array. If only a single value is provided in the array, that is
  # returned
  def percentile(threshold)
    if (count > 1)
      self.sort!
      # strip off the top 100-threshold
      threshold_index = (((100 - threshold).to_f / 100) * count).round
      self[0..-threshold_index].last
    else
      self.first
    end
  end

  # Calculates the mean squared error of values in the array
  def mean_squared
    m = mean
    self.class.new(map{|v| (v-m)**2}).sum
  end

  # Calculates the standard deviatiation of values in the array
  def standard_dev
    (mean_squared/(count-1))**0.5
  end

  # Allow [1,2,3].percentile_90, [1,2,3].percentile(75), etc.
  def method_missing(method, *args, &block)
     if method.to_s =~ /^percentile_(.+)$/
       percentile($1.to_i)
     else
       super
     end
  end

end
