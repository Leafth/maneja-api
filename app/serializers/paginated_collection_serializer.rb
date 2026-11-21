class PaginatedCollectionSerializer
  class << self
    def call(result:, serializer:, serializer_options: {})
      {
        data: ActiveModelSerializers::SerializableResource.new(
          result.records,
          each_serializer: serializer,
          **serializer_options
        ).as_json,
        meta: {
          page: result.page,
          per_page: result.per_page,
          total_items: result.total_items,
          total_pages: result.total_pages
        }
      }
    end
  end
end
