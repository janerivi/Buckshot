// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Represents a floating vertical list of selectable items.
 *
 * The [headerProperty] will not be visible unless the [Menu] is
 * associated with a [MenuStrip].
 */
class Menu extends Control implements IFrameworkContainer
{
  FrameworkProperty menuItemsProperty;
  FrameworkProperty parentNameProperty;
  FrameworkProperty headerProperty;
  FrameworkProperty _menuParentProperty;
  FrameworkProperty offsetXProperty;
  FrameworkProperty offsetYProperty;

  bool _isInitialized = false;

  final FrameworkEvent<MenuItemSelectedEventArgs> menuItemSelected =
      new FrameworkEvent<MenuItemSelectedEventArgs>();

  Menu()
  {
    Browser.appendClass(rawElement, "Menu");

    _initMenuProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = content;

    visibility = Visibility.collapsed;

    loaded + (_, __) => _initControl();

    registerEvent('menuitemselected', menuItemSelected);
  }

  Menu.register() : super.register();
  makeMe() => new Menu();

  void _initControl(){
    if (_isInitialized) return;
    _isInitialized = true;

    var mp = getValue(_menuParentProperty);

    if (mp == null){
      setValue(_menuParentProperty, parent);
    }

    _setPosition().then((_){
      if (menuItems.isEmpty()) return;

      menuItems.forEach((MenuItem item){
        item.click + (_, __){
          menuItemSelected.invoke(this, new MenuItemSelectedEventArgs(item));
          hide();
        };
      });

      if (visibility == Visibility.visible){
        show();
      }
    });

    document.body.on.click.add((e){
      if (visibility == Visibility.visible){
        hide();

        if (parent is MenuStrip){
          (parent as MenuStrip).hideAllMenus();
        }
      }
    });

  }

  void show(){
   _setPosition().then((_){
      visibility = Visibility.visible;
    });
  }

  void hide(){
    visibility = Visibility.collapsed;
  }

  Future _setPosition(){
    var mp = getValue(_menuParentProperty);
    if (mp == null) new Future.immediate(null);

    return mp
     .updateMeasurementAsync
     .chain((ElementRect r){
      rawElement.style.left = '${offsetX + r.bounding.left}px';
      rawElement.style.top = '${offsetY + r.bounding.top}px';
      return new Future.immediate(r);
    });
  }

  void _initMenuProperties(){
    menuItemsProperty = new FrameworkProperty(this, 'menuItems',
        defaultValue: new ObservableList<MenuItem>());

    _menuParentProperty = new FrameworkProperty(this, '_menuParent');

    offsetXProperty = new FrameworkProperty(this, 'offsetX',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    offsetYProperty = new FrameworkProperty(this, 'offsetY',
        defaultValue: 0,
        converter: const StringToNumericConverter());

    headerProperty = new FrameworkProperty(this, 'header');

    rawElement.style.position = 'absolute';
    rawElement.style.top = '0px';
    rawElement.style.left = '0px';
  }

  get content => getValue(menuItemsProperty);

  ObservableList<MenuItem> get menuItems => getValue(menuItemsProperty);

  set offsetX(num value) => setValue(offsetXProperty, value);
  num get offsetX => getValue(offsetXProperty);

  set offsetY(num value) => setValue(offsetYProperty, value);
  num get offsetY => getValue(offsetYProperty);

  set header(value) => setValue(headerProperty, value);
  get header => getValue(headerProperty);

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border shadowx='3'
            shadowy='3'
            shadowblur='6'
            zorder='32766'
            minwidth='20'
            minheight='20'
            borderthickness='1'
            bordercolor='LightGray'
            cursor='Arrow'>
      <collectionpresenter halign='stretch' collection='{template menuItems}'>
         <itemstemplate>
           <border padding='5' background='WhiteSmoke' halign='stretch'>
              <actions>
                <setproperty event='mouseEnter' property='background' value='LightGray' />
                <setproperty event='mouseLeave' property='background' value='WhiteSmoke' />
                <setproperty event='mouseDown' property='background' value='DarkGray' />
                <setproperty event='mouseUp' property='background' value='LightGray' />
              </actions>
              <contentpresenter content='{data}' />
           </border>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }
}
