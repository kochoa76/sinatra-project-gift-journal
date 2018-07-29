class Gift < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def slug
   self.name.downcase.gsub(" ", "-") if self.name
  end

  def self.find_by_slug(slug)
    self.all.find{|instance| instance.slug == slug}
  end
end
