import { AppTitleBar } from '../../widgets/AppTitleBar'
import { AppRadius } from '../../common/AppConstants'
@ComponentV2
export struct BottomSheetPage {
  x:string[] = ['1','2'];
  @Local show:boolean = false
  @Local show2:boolean = false
  @Local show3:boolean = false
  build() {
    Column() {
      Button('Hello').onClick(e=>{
        this.show=true
      }).bindSheet(this.show,bottomDialogWidget(this.x),{
        onWillAppear:()=>{},onAppear:()=>{},onWillDisappear:()=>{},onDisappear:()=>{
          this.show=false
        }
      })
      Button('Hello').onClick(e=>{
        this.show2=true
      }).bindSheet(this.show2,bottomDialogWidget(this.x),{
        height:200,
        onWillAppear:()=>{},onAppear:()=>{},onWillDisappear:()=>{},onDisappear:()=>{
          this.show2=false
        }
      })
      Button('Hello').onClick(e=>{
        this.show3=true
      }).bindSheet(this.show3,bottomDialogWidget(this.x),{
        detents: [SheetSize.MEDIUM, SheetSize.LARGE, 200],
        backgroundColor:$r('app.color.start_window_background'),
        blurStyle: BlurStyle.Thick,
        onWillAppear:()=>{},onAppear:()=>{},onWillDisappear:()=>{},onDisappear:()=>{
          this.show3=false
        }
      })
    }
  }
}
@Builder
function bottomDialogWidget(data:string[]){
  List(){
    ForEach(data,(item:string)=>{
      ListItem(){
        Text(item).height(100)
      }
    })
  }
  .borderRadius(AppRadius.screenSheet)
  .backgroundColor($r('app.color.app_surface'))
}
@Builder
export function BottomSheetPageBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: 'BottomSheetPage' })
      Column() {
        BottomSheetPage()
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%')
  }.hideTitleBar(true)
}
