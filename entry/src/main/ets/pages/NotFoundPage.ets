import { AppTitleBar } from '../widgets/AppTitleBar'
@ComponentV2
export struct NotFoundPage {
  build() {
    Column() {
      Text(':(\n\n404 Not found the page')
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .align(Alignment.Center)
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.app_background'))
  }
}
@Builder
export function NotFoundPageBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: 'NotFoundPage' })
      Column() {
        NotFoundPage()
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%')
  }.hideTitleBar(true)
}
