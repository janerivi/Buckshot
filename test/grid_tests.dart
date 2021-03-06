#library('grid_tests_buckshot');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:unittest/unittest.dart');

run(){
  group('Grid', (){
    test('attached properties < 0 == 0', (){
      TextBlock tb = new TextBlock();
      
      Grid.setColumn(tb, -5);
      Grid.setRow(tb, -5);
      Grid.setColumnSpan(tb, -5);
      Grid.setRowSpan(tb, -5);
      
      Expect.equals(0, Grid.getColumn(tb));
      Expect.equals(0, Grid.getRow(tb));
      Expect.equals(0, Grid.getColumnSpan(tb));
      Expect.equals(0, Grid.getRowSpan(tb));
    });
  });
}
