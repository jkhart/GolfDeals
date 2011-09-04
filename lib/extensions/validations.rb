class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      if Addressable::URI.parse(value).host.blank?
        record.errors[attribute] << (options[:message] || "is not a recognized url")
      end
    end
  end
end

class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      if options[:includes].present? && options[:includes].is_a?(Array) && !options[:includes].collect(&:to_s).include?(Addressable::URI.parse(value).host)
        record.errors[attribute] << (options[:message] || "is not allowed")
      end
      if options[:includes].present? && (options[:includes].is_a?(String) || options[:includes].is_a?(Symbol)) && (options[:includes].to_s != Addressable::URI.parse(value).host)
        record.errors[attribute] << (options[:message] || "must be ")
      end
      if options[:excludes].present? && options[:excludes].is_a?(Array) && options[:excludes].collect(&:to_s).include?(Addressable::URI.parse(value).host)
        record.errors[attribute] << (options[:message] || "is not allowed")
      end
      if options[:excludes].present? && (options[:excludes].is_a?(String) || options[:excludes].is_a?(Symbol)) && (options[:excludes].to_s == Addressable::URI.parse(value).host)
        record.errors[attribute] << (options[:message] || "must not be ")
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveModel::Validations)
