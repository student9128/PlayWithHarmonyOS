@Builder
export function HarmonyOSDevPageBuilder(){
  HarmonyOSDevPage()
}
@ComponentV2
export struct HarmonyOSDevPage {
  build() {
    Column() {
      Text('HarmonyOSDevPage')
    }
  }
}