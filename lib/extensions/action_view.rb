ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if html_tag =~ /<(input|textarea|select)[^>]+class=/
    class_attribute = html_tag =~ /class=['"]/
    html_tag.insert(class_attribute + 7, "field-with-errors ")
  elsif html_tag =~ /<(input|textarea|select)/
    first_whitespace = html_tag =~ / /
    html_tag[first_whitespace] = " class='field-with-errors' "
  end
  html_tag  
end
