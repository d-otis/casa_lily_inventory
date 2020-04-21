class LocationItem < ActiveRecord::Base
	belongs_to :item
	belongs_to :location

	def self.update_under_status_all
		LocationItem.where("item_count < item_par").update_all(under: true)
		LocationItem.where("item_count >= item_par").update_all(under: false)
	end

	def need
		result = self.item_par - self.item_count
		result > 0 ? result : "<span class='badge badge-pill badge-success'>Stocked</span>"
	end
end