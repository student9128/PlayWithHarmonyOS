import { showToast, showToastLong } from '../../utils/ToastUtils'
import { promptAction } from '@kit.ArkUI'
import { CustomTitleBar } from '../../widgets/CustomTitleBar'

@Entry
@Component
struct TextInputPage {
  build() {
    Column() {
      CustomTitleBar() {
        Column() {
          TextInput()
          Button('点击').onClick(() => {
            showToast('Hello', { alignment: Alignment.Center })
          })
          Button('变色 toast').onClick(() => {
            showToast('Hello', { backgroundColor: Color.Green })
          })
          Button('点击').onClick(() => {
            showToastLong('Hello', { alignment: Alignment.Center })
          })
        }
      }

    }
  }
}