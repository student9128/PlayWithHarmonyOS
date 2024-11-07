import { DrawerLayout } from '@smarthane/drawer-layout';

@Entry
@Component
struct DrawerLayoutPage{
  @State drawerModel: DrawerLayout.Model = new DrawerLayout.Model()
    .setDrawerType(DrawerLayout.Type.LEFT)
    .setDrawerWidth(300)
    .setMaskColor(Color.Transparent)
  aboutToAppear(): void {
    this.drawerModel.setDrawerStateCallback((drawerType,isOpen)=>{
      console.debug(`drawerType: ${drawerType}, isOpen: ${isOpen}`)
    })
  }
  onBackPress(): boolean | void {
    if(this.drawerModel.isDrawerOpen){
      this.drawerModel.closeDrawer();
      return true;
    }
    return false;
  }
  build() {
    Column(){
      DrawerLayout({model:$drawerModel,drawerView:()=>{this.buildDrawerView()},contentView:()=>{this.buildContentView()}}).height('100%')
    }
  }

  @Builder buildContentView(){
    Column(){
      Text('这是内容')
      Button('打开drawer').onClick(()=>{
        this.drawerModel.openOrCloseDrawer()
      })
    }
  }
  @Builder buildDrawerView(){
    Column(){
      Text('左边抽屉')
    } .backgroundColor(Color.Green)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}