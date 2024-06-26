import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct DataPanelPage {
  @State message: string = 'DataPanelPage'

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