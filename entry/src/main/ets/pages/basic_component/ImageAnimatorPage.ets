import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct ImageAnimatorPage {
  @Local message: string = "ImageAnimatorPage"

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
export function ImageAnimatorPageBuilder() {
  NavDestination() {
    ImageAnimatorPage()
  }.hideTitleBar(true)
}
