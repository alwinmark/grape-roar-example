Rspec::Matchers.define :have_link do |link_name|

  match do |ressource|
    result = check_ressource_has_link(ressource, link_name)
    result.to_s.start_with? "ok"
  end

  chain :with_href do |href|
    @href = href
  end

  chain :with_route do |route|
    @route = route
  end

  def check_ressource_has_link(ressource, link_name)
    if ressource["_links"].has_key?(link_name)
      if @href.nil?
        :ok_link_exists
      elsif @route.nil?
        if ressource["_links"][link_name].end_with? @route
          :ok_route
        else
          :fail_wrong_route
        end
      else
        if ressource["_links"][link_name].eq @href
          :ok_link_exists_with_value
        else
          :fail_wrong_href
        end
      end
    else
      :fail_link_does_not_exist
    end
  end

  description do
    message = "have a link called #{link_name}"
    message << " with href: '#{@href}'" unless @href.nil?
    message << " with route: '#{@route}'" unless @route.nil?
    message
  end

  failure_message_for_should do |ressource|
    case check_ressource_has_link(ressource, link_name)
    when :fail_wrong_href
      "found link but expected href to be: #{@href} instead of #{ressource["_links"][link_name]}"
    when :fail_link_does_not_exist
      "couldn't find the link #{link_name} in #{ressource.keys}"
    when :fail_wrong_route
      "found link #{link_name} but expected '#{ressource["_links"][link_name]}' to include route: '#{@route}'"
    end
  end

  failure_message_for_should_not do |ressource|
    case check_ressource_has_link(ressource, link_name)
    when :ok_link_exists
      "expected that the link #{link_name} does not exist"
    when :ok_link_exists_with_value
      "expected that the href of #{link_name} does not equal to #{@href}"
    when :ok_route
      "expected route to not equal #{@route}"
    end
  end
end
