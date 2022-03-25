require 'json'
require 'byebug'

KEYWORDS = [ "price", "prod", "li", "il", "ii", "acct", "test", "ch", "cus", "in", "evt", "card", "req", "pi", "pm", "secret", "src" ]

MATCH_REGEX = /(#{KEYWORDS.join('|')})_\w{12,96}/

REPLACE_LIST = {
  account_name: 'Example Company, Inc.',
  calculated_statement_descriptor: 'EXAMPLECOMPANY'
}

class Sanitizer
  def self.sanitize(string)
    string.gsub(/[^\w\s]/, '').gsub(/\s+/, ' ').strip
  end

  # Convert to a string of equal length 0's
  def self.sanitize(key, str)
    if REPLACE_LIST.key?(key.to_sym)
      return REPLACE_LIST[key.to_sym]
    elsif str =~ MATCH_REGEX
      return str.split('/').map do |section|
        if section.include?('_')
          str_arr = section.split('_')
          str_arr.each_with_index do |str, idx|
            str_arr[idx] = '0' * str_arr[idx].length unless KEYWORDS.include?(str)
          end
          str_arr.join('_')
        else
          section
        end
      end.join('/')
    else
      return str
    end
  end

  def self.traverse_and_sanitize(params)
    params.each_with_object({}) do |(key, value), result|
      if value =~ MATCH_REGEX || REPLACE_LIST.key?(key.to_sym)
        result[key] = sanitize(key, value)
      elsif value.is_a?(Hash)
        result[key] = traverse_and_sanitize(value)
      elsif value.is_a?(Array)
        result[key] = value.map {|v| v.is_a?(String) ? sanitize(key, v) : traverse_and_sanitize(v) }
      else
        result[key] = value
      end
    end
  end
end
