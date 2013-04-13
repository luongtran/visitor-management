class MigrateVisitor < ActiveRecord::Migration
  def up
    Visitor.find(:all, :conditions => ["user_id = 1"]).each do |visitor|
      Visitor.new(:authorized_id => visitor.authorized_id, :comment => visitor.comment, :here_to_meet => visitor.here_to_meet, :location => visitor.location,
                  :reason_to_visit => visitor.reason_to_visit, :storage_device_detail => visitor.storage_device_detail, :coming_from => visitor.coming_from,
                  :user_id => 6, :visitor_company_name => visitor.visitor_company_name, :visitor_mobile_number => visitor.visitor_mobile_number,
                  :visitor_name => visitor.visitor_name, :visitor_vehicle_number => visitor.visitor_vehicle_number, :pass_id => visitor.pass_id,
                  :photo => visitor.photo, :badge_number => visitor.badge_number).save
    end
  end

  def down
  end
end
