class Attachment < ActiveRecord::Base
  
  Paperclip::Attachment.default_options[:default_style] = :large
  
  attr_accessible :owner_id, :owner_type, :source
  
  belongs_to :owner, :polymorphic => true
  
  has_attached_file :source, :styles => { :large => "640x640>", :medium => "300x300>", :thumb => "150x150>"}, :default_url => "/images/:style/missing.png"
  
  def as_json(options={})
    super(:only => [:id, :source_file_name, :created_at], :methods => [:thumb_url, :origin_url])
  end
  
  def thumb_url
    Settings.base_url + self.source.url(:thumb)
  end
  
  def origin_url
    Settings.base_url + self.source.url(:large)
  end

end
