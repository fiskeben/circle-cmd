class Tabulator
  def initialize(data)
    @data = data
  end

  def with_headers(headers=[])
    @headers = headers
    self
  end

  def with_column_names(columns=[])
    @columns = columns
    self
  end

  def to_s
    if @headers.length != @columns.length
      raise ArgumentError.new("Number of headers and columns are not the same!")
    end
    calculate_column_widths
    @result = ""
    make_header
    make_body
    @result
  end

  private

  def calculate_column_widths
    @column_widths = {}
    @columns.each_with_index do |c,i|
      widths_for_column = @data.collect do |row|
        row[c].to_s.length
      end
      widths_for_column.push(@headers[i].length)
      @column_widths[c] = widths_for_column.max + 2
    end

    @total_width = @column_widths.values.reduce(:+) + @columns.length - 1

    limit_columns
  end

  def limit_columns
    width_of_terminal = terminal_width
    if @total_width > width_of_terminal
      widest_column = @column_widths.max_by do | key, value |
        value
      end
      p @column_widths[widest_column[0]]
      @column_widths[widest_column[0]] = @column_widths[widest_column[0]] - (@total_width - width_of_terminal)
      @total_width = width_of_terminal
      p @column_widths[widest_column[0]]
    end
  end

  def make_header
    @headers.each_with_index do |h, i|
      current_width = @column_widths[@columns[i]]
      value = h
      if h.length >= current_width
        value = h[0..(current_width-4)]
        value += "..."
      end

      @result += " #{value}"
      @result += " " * (current_width - value.length - 1)
      if i < @headers.length - 1
        @result += "|"
      end
    end
    @result += "\n" + "-" * @total_width + "\n"
  end

  def make_body
    @data.each do |item|
      @columns.each_with_index do |column_key, index|
        current_width = @column_widths[column_key]
        value = item[column_key].to_s
        if value.length >= current_width
          value = value[0..(current_width-5)]
          value += "..."
        end

        remaining_width = current_width - value.length - 1
        remaining_width = 0 if remaining_width < 0

        @result += " #{value}"
        @result += " " * remaining_width
        if index < @columns.length - 1
          @result += "|"
        end
      end
      @result += horizontal_line
    end
  end

  def horizontal_line
    "\n" + "-" * @total_width + "\n"
  end

  def terminal_width
    `tput cols`.to_i
  end
end
