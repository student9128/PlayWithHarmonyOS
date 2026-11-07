import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct MenuPage {
  @Local message: string = "MenuPage"

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
export function MenuPageBuilder() {
  NavDestination() {
    MenuPage()
  }.hideTitleBar(true)
}
