import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct SliderPage {
  @State message: string = "GaugePage"

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