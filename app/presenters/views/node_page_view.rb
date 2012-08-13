module Views
  class NodePageView < ViewPresenter

    def node_layout

    end

    def to_s
      @template.render
    end
  end
end