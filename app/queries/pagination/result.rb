module Pagination
  Result = Data.define(:records, :page, :per_page, :total_items, :total_pages)
end
