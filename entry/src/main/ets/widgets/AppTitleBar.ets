import { AppSize, AppTitleAlign, Constants } from '../common/AppConstants'

@ComponentV2
export struct AppTitleBar {
  @Consumer(Constants.pageNavStack) pageNavStack: NavPathStack = Constants.navStack
  @Param title: string = ''
  @Param titleAlign: number = AppTitleAlign.Center
  @Param barBackgroundColor: ResourceColor = $r('app.color.app_surface')
  @Event onBackClick?: () => void

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(AppSize.backIconSize)
          .height(AppSize.backIconSize)
          .fillColor($r('app.color.app_primary'))
      }
      .width(AppSize.backHitSize)
      .height(AppSize.backHitSize)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.onBackClick?.()
        this.pageNavStack.pop()
      })

      Text(this.title)
        .fontSize(AppSize.titleFontSize)
        .fontWeight(600)
        .fontColor($r('app.color.app_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(this.titleAlign === AppTitleAlign.Center ? TextAlign.Center : TextAlign.Start)
        .padding({ left: this.titleAlign === AppTitleAlign.Start ? 4 : 0 })
        .layoutWeight(1)

      // 无右侧按钮，仅保留等宽占位以对称居中
      Row()
        .width(AppSize.backHitSize)
        .height(AppSize.backHitSize)
    }
    .width('100%')
    .height(AppSize.titleBarHeight)
    .padding({ left: 4, right: 4 })
    // .backgroundColor(this.barBackgroundColor)
  }
}
