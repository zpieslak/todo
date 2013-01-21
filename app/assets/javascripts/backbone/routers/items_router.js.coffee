class Todo.Routers.ItemsRouter extends Backbone.Router
  initialize: (options) ->
    @items = new Todo.Collections.ItemsCollection()
    @items.reset options.items

  routes:
    "*filter" : "index"

  index: (param) ->
    param ||= ''
    @view = new Todo.Views.Items.IndexView(collection: @items, filter: param)
    $("#items").html(@view.render().el)
    @items.trigger('filter');
