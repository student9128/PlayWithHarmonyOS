import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@ComponentV2
export struct DatePickerPage {
  @Local message: string = 'DatePickerPage'

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
export function DatePickerPageBuilder() {
  NavDestination() {
    DatePickerPage()
  }.hideTitleBar(true)
}
