import { PlayFontStyle } from '../../common/FontStyle'
import { playFont } from '../../common/Global'
import { key_window_class } from '../../common/Key'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct OrientationSwitchPage {
  @State message: string = "OrientationSwitchPage"
  @State isPortrait: boolean = true;

  onBackPress(): boolean | void {
    console.log("onBackPress====="+this.isPortrait)
    if (!this.isPortrait) {
      let windowClass = AppStorage.get<window.Window>(key_window_class)
      windowClass?.setPreferredOrientation(window.Orientation.PORTRAIT)
      this.isPortrait=true
      return true
    }
    return false
  }

  build() {
    Column() {
      CustomTitleBar({ title: this.message }) {
        Column() {
          Text(this.message)
            .attributeModifier(new PlayFontStyle)
          // .fontSize(50)
          // .fontWeight(FontWeight.Bold)
          Button('切换横竖屏').onClick(() => {
            let windowClass = AppStorage.get<window.Window>(key_window_class)
            if (this.isPortrait) {
              windowClass?.setPreferredOrientation(window.Orientation.LANDSCAPE)
            } else {
              windowClass?.setPreferredOrientation(window.Orientation.PORTRAIT)
            }
            this.isPortrait = !this.isPortrait

          })
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}