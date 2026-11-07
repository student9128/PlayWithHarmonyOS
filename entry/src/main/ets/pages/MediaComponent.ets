import { AppTitleBar } from '../widgets/AppTitleBar'
@ComponentV2
export struct MediaComponent{
  build(){
    Column(){
      Text('MediaComponent')
    }
  }
}
@Builder
export function MediaComponentBuilder() {
  NavDestination() {
    Column() {
      AppTitleBar({ title: 'MediaComponent' })
      Column() {
        MediaComponent()
      }.width('100%').layoutWeight(1)
    }.width('100%').height('100%')
  }.hideTitleBar(true)
}
