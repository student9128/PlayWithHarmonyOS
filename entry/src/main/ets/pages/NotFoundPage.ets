@Entry
@Component
struct NotFoundPage {
  build() {
    Navigation() {
      Column() {
        Text(':(\n\n404 Not found the page')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .align(Alignment.Center)
          .width('100%')
          // .backgroundColor($r('app.color.tab_active_color'))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
      .backgroundColor($r('app.color.background_color'))
    }.title('Not found')
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.white'))

  }
}