@Builder
export function HarmonyOSDevPageBuilder(){
  HarmonyOSDevPage()
}
@Component
export struct HarmonyOSDevPage {
  build() {
    Column() {
      Text('HarmonyOSDevPage')
    }
  }
}