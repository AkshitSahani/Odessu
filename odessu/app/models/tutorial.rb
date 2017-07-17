class Tutorial < ApplicationRecord
  def self.get_csv_data
    require 'csv'
    csv_text = File.read('/Users/AkshitSahani/Desktop/bitmaker/projects/odessu/app/assets/voluptuousverified(7).csv', :encoding => 'ISO-8859-1')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Tutorial.create!(row.to_hash)
    end
  end
end
#code works. All columns in the CSV file need to be the exact same columns on the table. Any new info in csv files can be
#added to the table. Column names in csv files need to be names that are supported by rails as names for table columns.
