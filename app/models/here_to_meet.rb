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
  			record = find_by_id(row["badge_number"]) || new
  			record.attributes = row.to_hash.slice(*accessible_attributes)
        record.organization = user.organisation_name
  			record.save!
  		end	
  	end
end
