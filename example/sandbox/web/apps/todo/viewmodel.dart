
/// ViewModelBase allows the class to implement [FrameworkProperty]s
class ViewModel extends ViewModelBase
{
  FrameworkProperty dueDateProperty;
  FrameworkProperty taskNameProperty;
  FrameworkProperty statusTextProperty;
  FrameworkProperty statusColorProperty;
  FrameworkProperty itemsProperty;

  final Color bad = new Color.predefined(Colors.Red);
  final Color good = new Color.predefined(Colors.Green);

  ViewModel()
  {

    taskNameProperty = new FrameworkProperty(this, "taskName", defaultValue:"");

    dueDateProperty = new FrameworkProperty(this, "dueDate", defaultValue:"");

    statusTextProperty = new FrameworkProperty(this, "statusText", defaultValue:"");

    statusColorProperty = new FrameworkProperty(this, "statusColor", defaultValue:good);

    itemsProperty = new FrameworkProperty(this, "items", defaultValue:new ObservableList());

    registerEventHandler('onsubmit_handler', onSubmit_handler);
  }

  void addNewEntry(){
    if (taskName.isEmpty() || dueDate.isEmpty()){
      statusColor = bad;
      statusText = "Please make sure Task and Due Date are filled in.";
    }else{
      statusColor = good;
      statusText = "Task Added.";

      //using a DataTemplate so the view can bind to the list by referening the
      //property names in the map.
      // This saves the task of having to create a dedicated class
      items.add(new DataTemplate.fromMap({"date" : dueDate, "task" : taskName}));

      taskName = "";
      dueDate = "";
    }
  }

  void onSubmit_handler(sender, args){
    addNewEntry();
  }

  //convenience getters/setters for our properties.

  ObservableList get items => getValue(itemsProperty);

  String get taskName => getValue(taskNameProperty);
  set taskName(String value) => setValue(taskNameProperty, value);

  String get dueDate => getValue(dueDateProperty);
  set dueDate(String value) => setValue(dueDateProperty, value);

  String get statusText => getValue(statusTextProperty);
  set statusText(String value) => setValue(statusTextProperty, value);

  Color get statusColor => getValue(statusColorProperty);
  set statusColor(Color value) => setValue(statusColorProperty, value);

}
