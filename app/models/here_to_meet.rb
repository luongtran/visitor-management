require 'roo'

class HereToMeet < ActiveRecord::Base
  attr_accessible :email, :mobile_number, :name, :organization

  def self.import(file, user)
  	case File.extname(file.original_filename)
	  	when ".xls" then spreadsheet = Roo::Excel.new(file.path, nil, :ignore)
	  	when ".xlsx" then spreadsheet = Roo::Excelx.new(file.path, nil, :ignore)
	  	else    return false
  	end
  		header = spreadsheet.row(1)
  		(2..spreadsheet.last_row).each do |i|
  			row = Hash[[header, spreadsheet.row(i)].transpose]
  			record = find_by_id(row["id"]) || new
  			record.attributes = row.to_hash.slice(*accessible_attributes)
        record.organization = user.organisation_name
  			record.save!
  		end	
  	end
end
