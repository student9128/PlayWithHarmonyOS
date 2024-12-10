@Entry
@Component
struct BottomSheetPage {
  x:string[] = ['1','2'];
  @State show:boolean = false
  @State show2:boolean = false
  @State show3:boolean = false
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
}