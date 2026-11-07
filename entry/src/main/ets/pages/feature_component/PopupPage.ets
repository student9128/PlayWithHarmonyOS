import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { AppRadius } from '../../common/AppConstants'

@ComponentV2
export struct PopupPage {
  @Local show1: boolean = false
  @Local show2: boolean = false
  @Local show3: boolean = false
  @Local show4: boolean = false
  @Local show5: boolean = false

  @Builder
  popBuilder(str: string) {
    Text(str)
      .padding({
        left: 15,
        right: 15,
        top: 5,
        bottom: 5
      })
      .borderRadius(AppRadius.dialog)
      .backgroundColor($r('app.color.app_primary_container'))
  }

  build() {
    Column() {
      CustomTitleBar({ title: 'PopupPage' }) {
        Flex() {
          Button('测试1').onClick(() => {
            this.show1 = !this.show1
          }).bindPopup(this.show1, { builder: this.popBuilder('测试1哈哈哈红红火火恍恍惚惚'), enableArrow: false })
          Button('测试2')
            .onClick(() => {
              this.show2 = !this.show2
            })
            .bindPopup(this.show2,
              { builder: this.popBuilder('测试2'), popupColor: Color.Blue, backgroundBlurStyle: BlurStyle.NONE })
          Button('测试3').onClick(() => {
            this.show3 = !this.show3
          }).bindPopup(this.show3, { builder: this.popBuilder('测试3哈哈哈红红火火恍恍惚惚') })
          Text('文字测试')
            .backgroundColor(Color.Red)
            .fontColor(Color.White)
            .padding({
              left: 15,
              right: 15,
              top: 5,
              bottom: 5
            })
            .onClick(() => {
              this.show4 = !this.show4
            })
            .bindPopup(this.show4, { builder: this.popBuilder('文字测试') })
          Text('文字测试')
            .backgroundColor(Color.Green)
            .fontColor(Color.White)
            .gesture(LongPressGesture({ repeat: true }).onAction(e => {

              this.show5=true
              setTimeout(()=>{this.show5=false},2000)
            })).bindPopup(this.show5,{builder:this.popBuilder('哈哈哈')})

        }
      }

    }
  }
}
@Builder
export function PopupPageBuilder() {
  NavDestination() {
    PopupPage()
  }.hideTitleBar(true)
}
