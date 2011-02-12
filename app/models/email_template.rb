class EmailTemplate < ActiveRecord::Base
  attr_protected :name
  
  validates_presence_of :name
  validates_presence_of :subject
  validates_presence_of :body
  validates_uniqueness_of :name

  def render_body(options = {})
    render(self.body, options)
  end
  
  def render_subject(options = {})
    render(self.subject, options)
  end
  
  def self.perform_search(search, sort_column, sort_direction)
    order = "#{sort_column} #{sort_direction}"
    if search
      find(:all, :conditions => ["(name LIKE ?) OR (subject LIKE ?)", "%#{search}%", "%#{search}%"], :order => order)
    else
      find(:all, :order => order)
    end
  end
  
  private
  
    def render(text, options)
      Liquid::Template.parse(text).render(options)
    end
  
end
