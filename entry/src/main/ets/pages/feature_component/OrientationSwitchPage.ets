import { PlayFontStyle } from '../../common/FontStyle'
import { playFont } from '../../common/Global'
import { key_window_class } from '../../common/Key'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'
import { window } from '@kit.ArkUI'

/**
 * 恢复竖屏。抽成模块级函数，供页面组件与 NavDestination 的返回拦截共用。
 * window 实例来自 AppStorage，与组件生命周期无关，页面销毁时调用同样有效。
 */
function restorePortrait(): void {
  const windowClass: window.Window | undefined =
    AppStorage.get<window.Window>(key_window_class)
  windowClass?.setPreferredOrientation(window.Orientation.PORTRAIT)
}

@ComponentV2
export struct OrientationSwitchPage {
  @Local message: string = 'OrientationSwitchPage'
  @Local isPortrait: boolean = true

  aboutToDisappear(): void {
    // 兜底：任何离开页面的路径（pop / clear / 栈被重置）都恢复竖屏，
    // 避免把横屏方向带回 Tabs 首页
    restorePortrait()
  }

  build() {
    Column() {
      CustomTitleBar({
        title: this.message,
        // 点击标题栏返回：转场前就切回竖屏
        onBackClick: (): void => {
          restorePortrait()
        }
      }) {
        Column() {
          Text(this.message)
            .attributeModifier(new PlayFontStyle)
          Button('切换横竖屏').onClick(() => {
            const windowClass: window.Window | undefined =
              AppStorage.get<window.Window>(key_window_class)
            windowClass?.setPreferredOrientation(this.isPortrait ?
              window.Orientation.LANDSCAPE : window.Orientation.PORTRAIT)
            this.isPortrait = !this.isPortrait
          })
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}

@Builder
export function OrientationSwitchPageBuilder() {
  NavDestination() {
    OrientationSwitchPage()
  }
  .hideTitleBar(true)
  .onBackPressed((): boolean => {
    // 侧滑返回 / 物理返回键：切回竖屏后正常出栈（false = 不拦截返回）
    restorePortrait()
    return false
  })
}
