module Admins::GroupsHelper
  def table_row klass, attribute
    values = klass.send(attribute, true)

    if values.size == 1
      return content_tag :tr do
        content_tag(:td, attribute) +
        content_tag(:td, values.first)
      end
    else
      return content_tag :tr do
        content_tag(:td, attribute, rowspan: values.size) +
        content_tag(:td, values.first ) +
        values[1..-1].map{|v| content_tag :tr, content_tag(:td, v)}.join.html_safe
      end
    end
  end

  def add_more_link selector, opts={text:'Add more', classes: ''}
    link_to '#', class: "add-link #{opts[:classes]}", data: {selector: selector} do
      fa_icon 'plus', text: opts[:text]
    end
  end

  def remove_link selector, opts={text:'Remove', classes: ''}
    link_to '#', class: "remove-link #{opts[:classes]}", data: {selector: selector} do
      fa_icon 'times', text: opts[:text]
    end
  end

  def append_if_empty a, e=''
    if a.empty?
      a << e
    else
      a
    end
  end

  def available_containers
    orgUnits ||= ActiveLdap::Base.search(filter: 'objectClass=organizationalUnit',
                                         attributes: ['ou'], base:'ou=fkit,ou=groups,dc=chalmers,dc=it').map(&:first)
  end

  def abbrev_dn rdn
    # Remove {"ou"=>"groups"}, {"dc"=>"chalmers"}, {"dc"=>"it"}
    abbrev = rdn[0..-4]
    abbrev.map{|i| i.map{|k,v| "#{k}=#{v}"}}.join(",")
  end
end
