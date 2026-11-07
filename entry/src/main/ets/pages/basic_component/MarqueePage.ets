import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct MarqueePage {
  @Local message: string = "MarqueePage"

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
export function MarqueePageBuilder() {
  NavDestination() {
    MarqueePage()
  }.hideTitleBar(true)
}
