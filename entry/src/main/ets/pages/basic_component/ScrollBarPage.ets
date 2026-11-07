import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct ScrollBarPage {
  @Local message: string = "GaugePage"

  build() {
    Column() {
      CustomTitleBar({ title: this.message }) {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }}
    .height('100%')
  }
}
@Builder
export function ScrollBarPageBuilder() {
  NavDestination() {
    ScrollBarPage()
  }.hideTitleBar(true)
}
