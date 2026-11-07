import { key_window_class } from '../../common/Key'
import { window } from '@kit.ArkUI'
/**
 * 使用了setWindowSystemBarProperties的话需要将statusBarColor设置为透明式，否则expandSafeArea不生效
 */
@ComponentV2
export struct SafeAreaPage {
  aboutToAppear(): void {
    let windowClass = AppStorage.get<window.Window>(key_window_class)
    // let statusBarContentColor: string = this.context.config.colorMode == 0 ? '#BF9742' : '#8D493A';
    windowClass?.setWindowSystemBarProperties({
      statusBarColor: null, statusBarContentColor:null
    }, (err) => {
      console.log(`${JSON.stringify(err)}`);
    })
  }
  build() {
    Column() {
      Image('https://gips2.baidu.com/it/u=1651586290,17201034&fm=3028&app=3028&f=JPEG&fmt=auto&q=100&size=f600_800')
        .width('100%')
        .aspectRatio(4/3).expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP])
    }.width('100%').height('100%').clip(false)
  }
}
@Builder
export function SafeAreaPageBuilder() {
  // 沉浸式页面：图片必须直接顶到状态栏下层。
  // 不能加标题栏（会占 56vp），也不能多包一层布局容器，
  // 否则图片顶部不再与安全区边界重合，expandSafeArea 失效。
  NavDestination() {
    SafeAreaPage()
  }.hideTitleBar(true)
}
