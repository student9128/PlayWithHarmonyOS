import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct DatePickerPage {
  @State message: string = 'DatePickerPage'

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