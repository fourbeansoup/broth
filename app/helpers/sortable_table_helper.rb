module SortableTableHelper
  
  def sortable_table(objects, options = {})
    options.reverse_merge!(default_options(options, objects))
    render :partial => "shared/sortable_table/table", :locals => {:objects => objects, :options => options}
  end
  
  def fetch_model(object)
    return nil if object.blank?
    object.class
  end
  
  def fetch_headers(model)
    columns = model.column_names.collect {|column| column.to_sym}
    columns
  end
  
  def fetch_section_name(controller = params[:controller])
    name = controller.split("/").last
    name.humanize
  end
  
  def default_options(options, objects)
    options[:name] ||= fetch_section_name
    options[:model] ||= fetch_model(objects.first)
    options[:data] ||= fetch_headers(options[:model]) unless options[:model].nil?
    options[:headers] ||= options[:data].collect {|header| header.to_s.humanize}.flatten unless options[:model].nil?
    options[:link_action] ||= :show
    options[:controller] ||= params[:controller]
    options[:search] = true if options[:search].nil?
    options[:search_path] ||= url_for(:action => :index)
    options
  end

end