import { AppTitleAlign, appTitleAlign, Constants } from '../common/AppConstants'
import { AppTitleBar } from './AppTitleBar'

/**
 * 页面容器：标题栏 + 内容。
 * 状态管理 V2；@BuilderParam 是 V1/V2 通用装饰器，
 * 现有页面 CustomTitleBar({ title: 'x' }) { ...内容... } 的调用方式保持不变。
 */
@ComponentV2
export struct CustomTitleBar {
  @BuilderParam contentBuilder: () => void
  @Param title: string = ''
  /** -1 跟随全局设置；0 居左；1 居中 */
  @Param titleAlign: number = Constants.followGlobalTitleAlign
  // 可选：页面退出前的自定义动作（例如恢复竖屏），透传给 AppTitleBar
  @Event onBackClick?: () => void

  private currentTitleAlign(): number {
    if (this.titleAlign !== Constants.followGlobalTitleAlign) {
      return this.titleAlign
    }
    // @Trace 字段在 build 执行期间被读取，变化会自动触发本组件刷新
    return appTitleAlign().align === AppTitleAlign.Start ?
      AppTitleAlign.Start : AppTitleAlign.Center
  }

  build() {
    Column() {
      AppTitleBar({
        title: this.title,
        titleAlign: this.currentTitleAlign(),
        onBackClick: (): void => {
          this.onBackClick?.()
        }
      })
      Column() {
        this.contentBuilder()
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.app_background'))
  }
}
