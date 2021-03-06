#library('binding_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('RadioButtonGroup', (){
    test('Null RadioButton add', (){
      RadioButtonGroup rbg = new RadioButtonGroup();

      rbg.addRadioButton(null);

      Expect.isTrue(rbg.radioButtonList.isEmpty());
    });
    test('Fail on RadioButton already exists', (){
      RadioButtonGroup rbg = new RadioButtonGroup();

      RadioButton rb1 = new RadioButton();
      rb1.groupName = "test";
      rb1.value = "0";

      rbg.addRadioButton(rb1);

      Expect.throws(
          () => rbg.addRadioButton(rb1),
          (e) => (e is BuckshotException)
      );
    });
    test('Fail if groupName different', (){
      RadioButtonGroup rbg = new RadioButtonGroup();

      RadioButton rb1 = new RadioButton();
      rb1.groupName = "test";
      rb1.value = "0";

      rbg.addRadioButton(rb1);

      RadioButton rb2 = new RadioButton();
      rb2.groupName = "test2";
      rb2.value = "1";

      Expect.throws(
          () => rbg.addRadioButton(rb2),
          (e) => (e is BuckshotException)
      );
    });
    test('Succeed adding second button', (){
      RadioButtonGroup rbg = new RadioButtonGroup();

      RadioButton rb1 = new RadioButton();
      rb1.groupName = "test";
      rb1.value = "0";

      rbg.addRadioButton(rb1);

      RadioButton rb2 = new RadioButton();
      rb2.groupName = "test";
      rb2.value = "1";

      rbg.addRadioButton(rb2);

      Expect.equals(rbg.radioButtonList.length, 2);
    });
  });
}

