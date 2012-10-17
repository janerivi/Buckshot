// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* CollectionPresents provides a way to declaratively display a list of arbitrary
* data.
*
* ## Buckshot Template Usage Example:
*
*     <collectionpresenter datacontext="{data someCollection}">
*         <!--
*              presentationpanel defaults to Stack
*              so doesn't need to be declared unless you
*              want to change or customize
*         -->
*         <presentationpanel>
*             <stack></stack>
*         </presentationpanel>
*         <!--
*             itemstemplate declares the output that will be
*             added to the presentationpanel for each iteration
*             of the collection
*         -->
*         <itemstemplate>
*              <textblock text="{data somedata}"></textblock>
*         <itemstemplate>
*     </collectionpresenter>
*
* ## Try It Yourself
* Select the "Collections" example on the Buckshot Sandbox: [Try Buckshot](http://www.lucastudios.com/trybuckshot)
*/
class CollectionPresenter extends FrameworkElement implements IFrameworkContainer
{
  static const String SBO = '__CollectionPresenterData__';
  var _eHandler;

  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty<Panel> presentationPanel;

  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty<String> itemsTemplate;

  /** Represents the collection to be used by the CollectionPresenter */
  FrameworkProperty<Collection> collection;


  final FrameworkEvent<ItemCreatedEventArgs> itemCreated;

  CollectionPresenter()
  :
    itemCreated = new FrameworkEvent<ItemCreatedEventArgs>()
  {
    Browser.appendClass(rawElement, "collectionpresenter");
    _initCollectionPresenterProperties();

    registerEvent('itemcreated', itemCreated);
  }

  CollectionPresenter.register() : super.register(),
    itemCreated = new FrameworkEvent<ItemCreatedEventArgs>();
  makeMe() => new CollectionPresenter();

  void _initCollectionPresenterProperties(){

    presentationPanel =
        new FrameworkProperty(this, "presentationPanel", (Panel p){
      if (p.parent != null){
        throw const BuckshotException('(CollectionPresenter)'
            ' Element is already child of another element.');
      }

      if (!rawElement.elements.isEmpty())
         rawElement.elements[0].remove();

      p.loaded + (_,__) => _updateCollection();

      p.addToLayoutTree(this);

    }, new Stack());

    itemsTemplate = new FrameworkProperty(this, "itemsTemplate");

    collection = new FrameworkProperty(this, 'collection');
  }

  //IFrameworkContainer interface
  get containerContent => presentationPanel;

  void invalidate() => _updateCollection();

  void _updateCollection(){

    var values = collection.value;

    if (values == null){
      // fall back to dataContext as Collection source
      final dc = resolveDataContext();

      if (dc == null && presentationPanel.value.isLoaded){
        presentationPanel.value.children.clear();
        return;
      } else if (dc == null){
          return;
      }

      values = dc.value;
    }

    if (values is ObservableList && _eHandler == null){
      _eHandler = values.listChanged + (_, __) {
        presentationPanel.value.children.clear();
        _updateCollection();
      };
    }

    if (values is! Collection)
      throw const BuckshotException("Expected dataContext object"
        " to be of type Collection.");

    presentationPanel.value.rawElement.elements.clear();

    if (itemsTemplate == null){
      //no template, then just call toString on the object.
      values.forEach((iterationObject){
        Template.deserialize('<textblock halign="stretch">'
          '${iterationObject}</textblock>')
          .then((it){
            it.stateBag[SBO] = iterationObject;
            itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
            presentationPanel.value.children.add(it);
          });
      });
    }else{
      //if template, then bind the object to the template datacontext
      values.forEach((iterationObject){
        Template
        .deserialize(itemsTemplate.value)
        .then((it){
          it.stateBag[SBO] = iterationObject;
          it.dataContext = iterationObject;
          itemCreated.invokeAsync(this, new ItemCreatedEventArgs(it));
          presentationPanel.value.children.add(it);
        });
      });
    }
  }
}


class ItemCreatedEventArgs extends EventArgs{
  final Dynamic itemCreated;

  ItemCreatedEventArgs(this.itemCreated);
}
