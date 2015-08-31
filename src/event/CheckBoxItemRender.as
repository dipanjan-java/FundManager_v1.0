package event
{
        import mx.containers.Canvas;
        import mx.controls.CheckBox;
        import mx.controls.dataGridClasses.DataGridListData;
        import mx.controls.listClasses.BaseListData;
        import mx.controls.listClasses.IDropInListItemRenderer;

	public class CheckBoxItemRender extends Canvas implements IDropInListItemRenderer
	{
	            private var _listData:DataGridListData;
                private var _instanceCheckBox:CheckBox = new CheckBox();
                private var _currentDataFieldName:String = new String();
       
        public function CheckBoxItemRender()
        {
                super();
        }

   override public function set data(value:Object):void {
            super.data = value;
            _instanceCheckBox.data=value[_listData.dataField];
            if(value[_listData.dataField] ==true){
            _instanceCheckBox.selected=true
                }
                else if(value[_listData.dataField] ==false){
                _instanceCheckBox.selected=false
                }
            }

        public function get listData():BaseListData
        {
                return _listData;
        }

        public function set listData(value:BaseListData):void
        {
                _listData = DataGridListData(value);
        }
       
        override protected function createChildren():void {
                super.createChildren();
                addChild(_instanceCheckBox);
        }

   }
}