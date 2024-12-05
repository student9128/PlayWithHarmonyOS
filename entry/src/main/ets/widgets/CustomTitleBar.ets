@Component
export struct CustomTitleBar {
  @BuilderParam contentBuilder: () => void
  @Prop title: string = ''
  build() {
    Navigation() {
      this.contentBuilder()
    }.titleMode(NavigationTitleMode.Mini)
    .title(this.NavTitle())
    .mode(NavigationMode.Stack)
  }
  @Builder
  NavTitle() {
    Text(this.title)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor($r('app.color.text_color'))
      .height('100%')
      .textAlign(TextAlign.Center)
  }
}