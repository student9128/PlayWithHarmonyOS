import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct DataPanelPage {
  @Local message: string = 'DataPanelPage'

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
export function DataPanelPageBuilder() {
  NavDestination() {
    DataPanelPage()
  }.hideTitleBar(true)
}
