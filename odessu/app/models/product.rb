class Product < ApplicationRecord
  belongs_to :store, optional: true
  has_many :order_items
  has_many :wish_list_items

  def self.get_csv_data
    require 'csv'
    csv_text = File.read('/Users/AkshitSahani/Desktop/bitmaker/projects/odessu/app/assets/voluptuousverified.csv', :encoding => 'ISO-8859-1')
    csv = CSV.parse(csv_text, :headers => true)

    csv.each do |row|
      Product.create!(row.to_hash)
    end
  end

  def get_product_colors
    self.color.split("Choose an option")[1].scan(/[[:upper:]]+[[:lower:]]+/)
  end

  def get_product_sizes
    self.size.split("Choose an option")[1]
  end

  def test(string)
    tests = string.chars
    count = (tests.count)/2
    a = []
    count.times do a << [] end
    i = 0
    tests.each do |x|
      a[i] << x
      i+=1 if x == "X"
    end
    a.map {|x| x.join('')}
  end
end
