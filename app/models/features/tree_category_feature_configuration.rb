module Features
  class TreeCategoryFeatureConfiguration < FeatureConfiguration
    include Ejans::Features::Filterable

    belongs_to :category
    validates :category, presence: true

    def data_for_node
      super.merge({
        :"#{machine_name}_category_name" => category.try(:name)
      })
    end

    def category_levels
      unless @category_levels
        @category_levels = category.levels
        @category_levels.shift
      end
      @category_levels
    end

    def level_size
      category_levels.size
    end

    def form_machine_names
      1.upto(level_size).map { |l| "#{machine_name}_level_#{l}" }
    end

    def filter_query(params = {})
      category.levels.size.times do |i|
        prm = params[form_machine_names[-(i+1)]]
        if prm.present?
          category_id = Category.find(prm).id
          @query = NodeQuery.new.in(:"#{where}" => [category_id])
          break
        else
          @query = NodeQuery.new
        end
      end
      @query
    end

    private
    def where
      "features." +
      "#{key_name}_ids"
    end
  end
end