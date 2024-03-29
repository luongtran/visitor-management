require 'roo'

class HereToMeet < ActiveRecord::Base
  attr_accessible :email, :mobile_number, :name, :organization, :badge_nubmer

  def self.import(file, user)
    return false if !file
  	case File.extname(file.original_filename)
	  	when ".xls" then spreadsheet = Roo::Excel.new(file.path, nil, :ignore)
	  	when ".xlsx" then spreadsheet = Roo::Excelx.new(file.path, nil, :ignore)
	  	else    return false
  	end
  		header = spreadsheet.row(1)
  		(2..spreadsheet.last_row).each do |i|
  			row = Hash[[header, spreadsheet.row(i)].transpose]
  			record = self.new
  			record.attributes = row.to_hash.slice(*accessible_attributes)
        record.organization = user.organisation_name
        record.mobile_number = record.mobile_number.to_s.gsub(".0", "") #roo returns '.0' at the end if a number
  			record.save!
  		end	
  	end
end
