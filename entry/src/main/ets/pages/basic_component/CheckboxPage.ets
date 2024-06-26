import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct CheckboxPage {
  @State message: string = 'CheckboxPage'

  build() {
    Column() {
      CustomTitleBar({ title: this.message }) {
        Column() {
          Text(this.message)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}